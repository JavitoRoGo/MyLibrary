//
//  MaxAndMinExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/8/23.
//

import SwiftUI

extension MaxAndMin {
    var maxOfMax: Int {
        datas.max { item1, item2 in
            item2.maxValue > item1.maxValue
        }?.maxValue ?? 0
    }
    var minOfMax: Int {
        datas.min { item1, item2 in
            item1.maxValue < item2.maxValue
        }?.maxValue ?? 0
    }
    
    var minOfMin: Int {
        datas.min { item1, item2 in
            item1.minValue < item2.minValue
        }?.minValue ?? 0
    }
    var maxOfMin: Int {
        datas.max { item1, item2 in
            item2.minValue > item1.minValue
        }?.minValue ?? 0
    }
    
    var maxForXAxis: Int {
        datas.count + 1
    }
    
    func animateGraph() {
        for (index, _) in datas.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    datas[index].animate = true
                }
            }
        }
    }
    
    struct MaxAndMinModifier: ViewModifier {
        @Environment(\.colorScheme) var colorScheme
        
        func body(content: Content) -> some View {
            content
                .padding()
                .background {
                    if colorScheme == .dark {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.gray.opacity(0.3).shadow(.drop(radius: 2)))
                    } else {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white.shadow(.drop(radius: 2)))
                    }
                }
                .navigationTitle("Máximos y mínimos")
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
        }
    }
}
