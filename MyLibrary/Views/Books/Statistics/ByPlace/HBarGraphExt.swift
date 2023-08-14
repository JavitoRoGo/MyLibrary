//
//  HBarGraphExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import Foundation

extension HBarGraph {
    func getGraphLines() -> [Double] {
        let max = getMax()
        var lines: [Double] = []
        lines.append(max)
        
        for index in 1...4 {
            let progress = max / 4
            lines.insert(max - (progress * Double(index)), at: 0)
        }
        
        return lines
    }
    
    func getMax() -> Double {
        let max = datas.max() ?? 0
        return max
    }
    
    func getBarWidth(point: Double, size: CGSize) -> Double {
        let max = getMax()
        let width = (point / max) * (size.width - 74)
        return width
    }
}
