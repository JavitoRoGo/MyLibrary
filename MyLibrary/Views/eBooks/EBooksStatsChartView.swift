//
//  EBooksStatsChartView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 16/1/23.
//

import Charts
import SwiftUI

struct EBooksStatsChartView: View {
    @EnvironmentObject var model: UserViewModel
    
    let titles = ["Autor", "Propietario", "Estado"]
    @State private var pickerSelection = 1
    @State private var graphKey = "Número de ebooks"
    @State private var dataSelection = 0
    
    var body: some View {
        VStack(spacing: 20) {
            Picker("Categoría", selection: $pickerSelection.animation(.easeInOut(duration: 0.8))) {
                ForEach(titles.indices, id:\.self) { index in
                    Text(titles[index])
                }
            }
            .pickerStyle(.segmented)
            
            HStack {
                HStack {
                    Capsule()
                        .fill(.blue)
                        .frame(width: 20, height: 8)
                    Text(graphKey)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Menu {
                    Button("eBooks") {
                        withAnimation(.linear(duration: 1.2)) {
                            graphKey = "Número de ebooks"
                            dataSelection = 0
                        }
                    }
                    Button("Páginas") {
                        withAnimation(.linear(duration: 1.2)) {
                            graphKey = "Número de páginas"
                            dataSelection = 1
                        }
                    }
                    Button("Precio") {
                        withAnimation(.linear(duration: 1.2)) {
                            graphKey = "Precio, €"
                            dataSelection = 2
                        }
                    }
                } label: {
                    Text("Mostrar")
                        .font(.caption)
                }
            }
            ScrollView {
                Chart(model.arrayOfEbookLabelsByCategoryForPickerAndGraph(tag: pickerSelection), id:\.self) { element in
                    let value = model.datasForGraph(statName: pickerSelection, dataName: dataSelection, text: element)
                    BarMark(
                        x: .value("Cantidad", value),
                        y: .value("Valor", element)
                    ).annotation(position: .trailing, alignment: .center) {
                        Text(
                            dataSelection == 2 ?
                            priceFormatter.string(from: NSNumber(value: value))! :
                                noDecimalFormatter.string(from: NSNumber(value: value))!
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .chartPlotStyle { plot in
                    plot.frame(height: 60 * CGFloat(model.arrayOfEbookLabelsByCategoryForPickerAndGraph(tag: pickerSelection).count))
                }
                .chartXAxis {
                    AxisMarks(position: .top)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThickMaterial)
    }
}

struct EBooksStatsChartView_Previews: PreviewProvider {
    static var previews: some View {
        EBooksStatsChartView()
            .environmentObject(UserViewModel())
    }
}
