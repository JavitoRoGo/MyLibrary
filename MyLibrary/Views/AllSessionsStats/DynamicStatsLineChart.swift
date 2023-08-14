//
//  DynamicStatsLineChart.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/6/22.
//

import SwiftUI

struct DynamicStatsLineChart: View {
    @EnvironmentObject var model: ReadingSessionModel
    
    let graphSelected: Int
    
    @State var percentage: CGFloat = 0.0
    
    var body: some View {
        VStack {
            LinearGradient(colors: [.green, .purple, .blue,.red, .orange, .yellow], startPoint: .leading, endPoint: .trailing).mask(chartView(datas: datas))
                .offset(x: graphSelected == 0 ? -30 :
                        graphSelected == 1 ? -5 :
                            graphSelected == 2 ? -20 : -50, y: -10)
            xLabels
                .offset(x: graphSelected == 0 ? 5 :
                            graphSelected == 1 ? 5 :
                            graphSelected == 2 ? 13 : 0)
        }
		.modifier(DynamicLineCharModifier(graphSelected: graphSelected, percentage: $percentage))
    }
}

struct DynamicStatsLineChart_Previews: PreviewProvider {
    static var previews: some View {
        DynamicStatsLineChart(graphSelected: 2)
            .environmentObject(ReadingSessionModel())
    }
}
