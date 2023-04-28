//
//  RDGlobalStats.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/12/22.
//

import SwiftUI

struct RDGlobalStats: View {
    @EnvironmentObject var model: RDModel
    @State private var datas: [RDGlobalStatsData] = [RDGlobalStatsData(title: "Libros:", paper: "81", kindle: "60", total: "141")]
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    VStack {
                        Image(systemName: "books.vertical")
                        Text("Libros")
                    }
                        .foregroundColor(.green)
                    Spacer()
                    VStack {
                        Image(systemName: "book.circle.fill")
                        Text("eBooks")
                    }
                        .foregroundColor(.orange)
                    Spacer()
                    Text("Total")
                }
                ForEach(datas, id: \.title) { data in
                    RDGlobalStatsRow(data: data)
                }
            }
            .navigationTitle("Desglose por formato")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadData)
        }
    }
    
    func loadData() {
        datas = [
            .init(title: "Registros:",
                  paper: String(model.calcRDBooks(.paper)),
                  kindle: String(model.calcRDBooks(.kindle)),
                  total: String(model.readingDatas.count)),
            .init(title: "Páginas:",
                  paper: noDecimalFormatter.string(from: NSNumber(value: model.calcRDPages(.paper).total))!,
                  kindle: noDecimalFormatter.string(from: NSNumber(value: model.calcRDPages(.kindle).total))!,
                  total: noDecimalFormatter.string(from: NSNumber(value: model.calcRDPages().total))!),
            .init(title: "Páginas promedio:",
                  paper: String(model.calcRDPages(.paper).mean),
                  kindle: String(model.calcRDPages(.kindle).mean),
                  total: String(model.calcRDPages().mean)),
            .init(title: "Tiempo:",
                  paper: minPerDayDoubleToString(model.calcRDDuration(.paper).total),
                  kindle: minPerDayDoubleToString(model.calcRDDuration(.kindle).total),
                  total: minPerDayDoubleToString(model.calcRDDuration().total)),
            .init(title: "Tiempo promedio:",
                  paper: minPerDayDoubleToString(model.calcRDDuration(.paper).mean),
                  kindle: minPerDayDoubleToString(model.calcRDDuration(.kindle).mean),
                  total: minPerDayDoubleToString(model.calcRDDuration().mean)),
            .init(title: "Velocidad promedio:",
                  paper: minPerPagDoubleToString(model.calcRDMinPerPag(.paper)),
                  kindle: minPerPagDoubleToString(model.calcRDMinPerPag(.kindle)),
                  total: minPerPagDoubleToString(model.meanMinPerPag)),
            .init(title: "Dedicación promedio:",
                  paper: minPerDayDoubleToString(model.calcRDMinPerDay(.paper)),
                  kindle: minPerDayDoubleToString(model.calcRDMinPerDay(.kindle)),
                  total: minPerDayDoubleToString(model.meanMinPerDay)),
            .init(title: "pág/día promedio:",
                  paper: String(model.calcRDPagPerDay(.paper)),
                  kindle: String(model.calcRDPagPerDay(.kindle)),
                  total: String(Int(model.meanPagPerDay))),
            .init(title: "Valoración promedio:",
                  paper: measureFormatter.string(from: NSNumber(value: model.meanRDRating(.paper)))!,
                  kindle: measureFormatter.string(from: NSNumber(value: model.meanRDRating(.kindle)))!,
                  total: measureFormatter.string(from: NSNumber(value: model.meanRDRating()))!)
        ]
    }
}

struct RDGlobalStats_Previews: PreviewProvider {
    static var previews: some View {
        RDGlobalStats()
            .environmentObject(RDModel())
    }
}
