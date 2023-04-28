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
    var datas: [Double] {
        model.graphData(tag: graphSelected)
    }
    var spacing: CGFloat {
        if graphSelected == 0 {
            return -10
        }
        if graphSelected == 1 {
            return 40
        }
        if graphSelected == 2 {
            return 10
        }
        if graphSelected == 3 {
            return 0
        }
        return 0
    }
    var maxY: Double {
        datas.max() ?? 0
    }
    var minY: Double {
        datas.min() ?? 0
    }
    @State private var percentage: CGFloat = 0.0
    
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
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 300)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThickMaterial)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
        .onChange(of: graphSelected) { _ in
            percentage = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
    
    func getGraphLines() -> [Double] {
        var lines: [Double] = []
        lines.append(maxY)
        
        for index in 1...4 {
            let progress = maxY / 4
            lines.append(maxY - (progress * Double(index)))
        }
        
        return lines
    }
}

struct DynamicStatsLineChart_Previews: PreviewProvider {
    static var previews: some View {
        DynamicStatsLineChart(graphSelected: 2)
            .environmentObject(ReadingSessionModel())
    }
}


extension DynamicStatsLineChart {
    @ViewBuilder
    func chartView(datas: [Double]) -> some View {
        GeometryReader { geo in
            Path { path in
                for index in datas.indices {
                    let xPosition = geo.size.width / CGFloat(datas.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((datas[index] - minY) / yAxis)) * geo.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            .shadow(color: .gray, radius: 10, x: 0, y: 10)
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    var xLabels: some View {
        HStack(spacing: spacing) {
            ForEach(model.getXLabels(tag: graphSelected), id: \.self) {
                Text($0)
            }
            .frame(maxWidth: .infinity)
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}
