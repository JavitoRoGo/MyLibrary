//
//  RSBarGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/6/22.
//

import Charts
import SwiftUI

struct RSBarGraph: View {
    let datas: [Double]
    let labels: [String]
    
    @State private var showingOldGraph = 0
    let buttons = ["SwiftCharts", "Clásica"]
    
    var body: some View {
        VStack {
            Picker("Elige gráfica", selection: $showingOldGraph.animation(.easeInOut)) {
                ForEach(0...1, id:\.self) { num in
                    Text(buttons[num])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            if showingOldGraph == 0 {
                NewBarGraph(datas: datas, labels: labels)
            } else if showingOldGraph == 1 {
                OldBarGraph(datas: datas, labels: labels)
            }
        }
    }
}

struct RDBarGraph_Previews: PreviewProvider {
    static let datas = [25.0, 63.0, 11.0]
    static let labels = ["11/10", "10/10", "9/10"]
    
    static var previews: some View {
        RSBarGraph(datas: datas, labels: labels)
            .environmentObject(RDModel())
            .environmentObject(ReadingSessionModel())
    }
}
