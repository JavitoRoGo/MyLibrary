//
//  OtherGraphs.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/10/22.
//

import Charts
import SwiftUI

struct OtherGraphs: View {
    @Environment(GlobalViewModel.self) var model
    
    let titles = ["Autor", "Editorial", "Encuadernación", "Propietario", "Estado"]
    @State private var pickerSelection = 2
    @State private var graphKey = "Número de libros"
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
                    Button("Libros") {
                        withAnimation(.linear(duration: 1.2)) {
                            graphKey = "Número de libros"
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
                    Button("Grosor") {
                        withAnimation(.linear(duration: 1.2)) {
                            graphKey = "Grosor, cm"
                            dataSelection = 3
                        }
                    }
                    Button("Peso") {
                        withAnimation(.linear(duration: 1.2)) {
                            graphKey = "Peso, g"
                            dataSelection = 4
                        }
                    }
                } label: {
                    Text("Mostrar")
                        .font(.caption)
                }
            }
            ScrollView {
				Chart(model.userLogic.arrayOfBookLabelsByCategoryForPickerAndGraph(tag: pickerSelection), id:\.self) { element in
					let value = model.userLogic.datasForOtherGraph(statName: pickerSelection, dataName: dataSelection, text: element)
                    BarMark(
                        x: .value("Cantidad", value),
                        y: .value("Valor", element)
                    ).annotation(position: .trailing, alignment: .center) {
                        Text(
                            dataSelection == 2 ?
							"\(value.formatted(.currency(code: "eur")))" :
								value.formatted(.number)
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .chartPlotStyle { plot in
					plot.frame(height: 60 * CGFloat(model.userLogic.arrayOfBookLabelsByCategoryForPickerAndGraph(tag: pickerSelection).count))
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

struct OtherGraphs_Previews: PreviewProvider {
    static var previews: some View {
        OtherGraphs()
			.environment(GlobalViewModel.preview)
    }
}
