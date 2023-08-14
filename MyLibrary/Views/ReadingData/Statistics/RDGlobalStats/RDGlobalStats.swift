//
//  RDGlobalStats.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/12/22.
//

import SwiftUI

struct RDGlobalStats: View {
    @EnvironmentObject var model: RDModel
    @State var datas: [RDGlobalStatsData] = [RDGlobalStatsData(title: "Libros:", paper: "81", kindle: "60", total: "141")]
    
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
}

struct RDGlobalStats_Previews: PreviewProvider {
    static var previews: some View {
        RDGlobalStats()
            .environmentObject(RDModel())
    }
}
