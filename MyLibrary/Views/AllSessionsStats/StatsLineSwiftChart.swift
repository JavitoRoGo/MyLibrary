//
//  StatsLineSwiftChart.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/10/22.
//

import Charts
import SwiftUI

struct StatsLineSwiftChart: View {
    let graphSelection: Int
    
    @State private var isLineGraph = false
    
    var body: some View {
        VStack {
            switch graphSelection {
            case 1:
                MonthChart(isLineGraph: $isLineGraph)
            case 2:
                YearChart(isLineGraph: $isLineGraph)
            case 3:
                TotalChart(isLineGraph: $isLineGraph)
            default:
                WeekChart(isLineGraph: $isLineGraph)
            }
            
            Toggle("Gráfica de línea", isOn: $isLineGraph)
                .padding(.top)
        }
        .frame(height: 350)
    }
}

struct StatsLineSwiftChart_Previews: PreviewProvider {
    static var previews: some View {
        StatsLineSwiftChart(graphSelection: 0)
    }
}
