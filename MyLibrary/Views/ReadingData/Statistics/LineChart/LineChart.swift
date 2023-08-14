//
//  LineChart.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/4/22.
//

import Charts
import SwiftUI

struct LineChart: View {
    @State private var pickerSelection = 0
    let titles = ["SwiftCharts", "Clásica"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Selección de gráfico", selection: $pickerSelection.animation(.easeInOut)) {
                    ForEach(titles.indices, id:\.self) { index in
                        Text(titles[index])
                    }
                }
                .pickerStyle(.segmented)
                
                if pickerSelection == 0 {
                    NewLineGraph()
                } else if pickerSelection == 1 {
                    OldLineChart()
                }
            }
            .padding()
            Spacer()
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
        }
        .navigationTitle("pág/día")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart()
            .environmentObject(RDModel())
    }
}
