//
//  NewLineGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import Charts
import SwiftUI

struct NewLineGraph: View {
    @EnvironmentObject var model: RDModel
    @State private var datasForLineChart: [DataForLineChart] = []
    
    var body: some View {
        Chart(datasForLineChart, id: \.name) { serie in
            ForEach(0..<serie.value.count, id: \.self) { index in
                LineMark(
                    x: .value("Libro", index),
                    y: .value("Valor", serie.animate[index] ? serie.value[index] : 0)
                )
                .interpolationMethod(.catmullRom)
            }
            .foregroundStyle(by: .value("Tipo", serie.name))
            
            RuleMark(y: .value("media", model.meanPagPerDay))
                .foregroundStyle(.black).lineStyle(.init(lineWidth: 3))
                .annotation(alignment: .leading) {
                    Text("media: \(model.meanPagPerDay, format: .number.precision(.fractionLength(0)))")
                        .font(.caption)
                    
                }
        }
        .chartXAxis(.hidden)
        .chartForegroundStyleScale(["pág/d": .blue.opacity(0.4), "Evolución": .red.opacity(0.4)])
        .task {
            datasForLineChart = [
                .init(name: "pág/d", value: model.datas().0, animate: .init(repeating: false, count: model.datas().0.count)),
                .init(name: "Evolución", value: model.datas().1, animate: .init(repeating: false, count: model.datas().1.count))
            ]
            animateGraph()
        }
    }
    
    func animateGraph() {
        for (index, serie) in datasForLineChart.enumerated() {
            for (subindex, _) in serie.animate.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(subindex) * 0.01) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        datasForLineChart[index].animate[subindex] = true
                    }
                }
            }
        }
    }
}
