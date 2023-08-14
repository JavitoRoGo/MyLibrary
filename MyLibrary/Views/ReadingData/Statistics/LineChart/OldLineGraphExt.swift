//
//  OldLineGraphExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension OldLineChart {
    func getGraphLines() -> [Double] {
        let max = getMax()
        var lines: [Double] = []
        lines.append(max)
        
        for index in 1...4 {
            let progress = max / 4
            lines.append(max - (progress * Double(index)))
        }
        return lines
    }
    
    func getMax() -> Double {
        let max = datas.0.max() ?? 0
        return max
    }
    
    @ViewBuilder
    func chartView(datas: [Double]) -> some View {
        GeometryReader { geometry in
            Path { path in
                for index in datas.indices {
                    let xPosition = geometry.size.width / CGFloat(datas.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((datas[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: .gray, radius: 10, x: 0, y: 10)
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartXLabels: some View {
        HStack {
            Text("Lo")
            Spacer()
            Text("Hi")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}
