//
//  OldLineGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

struct OldLineChart: View {
    @EnvironmentObject var model: RDModel
    var datas: ([Double], [Double]) {
        model.datas()
    }
    var maxY: Double {
        datas.0.max() ?? 0
    }
    var minY: Double {
        //        datas.0.min() ?? 0
        0
    }
    
    @State var percentage: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 140) {
                ForEach(getGraphLines(), id: \.self) { line in
                    HStack(spacing: 8) {
                        Text(Int(line), format: .number)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(height: 20)
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: -10)
                }
            }
            
            ZStack {
                chartView(datas: datas.0)
                    .foregroundColor(.blue)
                chartView(datas: datas.1)
                    .foregroundColor(.red)
                chartView(datas: Array(repeating: model.meanPagPerDay, count: datas.0.count))
                    .foregroundColor(.primary)
            }
            .padding(.leading, 30)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}
