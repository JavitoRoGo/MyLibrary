//
//  BarGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/4/22.
//

import SwiftUI

struct HBarGraph: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    
    let tag: Int
    var datas: [Double] {
        bmodel.datas(tag: tag)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    ForEach(getGraphLines(), id: \.self) { line in
                        VStack(spacing: 8) {
                            Text(Int(line), format: .number)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .frame(height: 20)
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .frame(width: 1)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: 10)
                    }
                }
                
                HStack(spacing: 0) {
                    VStack {
                        ForEach(model.myPlaces, id: \.self) { place in
                            Text(place)
                                .font(.caption)
                                .frame(width: 25, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .offset(x: 10)
                    VStack(alignment: .leading) {
                        ForEach(datas.indices, id:\.self) { index in
                            AnimatedBarGraph(index: index, showOver50: false)
                                .frame(width: getBarWidth(point: datas[index], size: geo.size))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    }
                    .offset(x: -27)
                }
                .padding(.top, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
    
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

struct HBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        HBarGraph(tag: 0)
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
    }
}
