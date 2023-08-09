//
//  MyRing.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

struct MyRing: View {
    @State private var show = false
    let datas: [Int]
    let index: Int
    var separator: Double {
        Double(datas.reduce(0, +)) / 100 * 0.3
    }
    var fromTrim: Double {
        if index == 0 {
            return separator / Double(datas.reduce(0, +))
        } else {
            var sum = 0.0
            for i in 0..<index {
                sum += Double(datas[i])
            }
            return (sum + separator) / Double(datas.reduce(0, +))
        }
    }
    var toTrim: Double {
        fromTrim + (Double(datas[index]) - separator) / Double(datas.reduce(0, +))
    }
    
    var body: some View {
        Circle()
            .trim(from: fromTrim, to: show ? toTrim : 0)
            .stroke(lineWidth: 150)
            .rotationEffect(.init(degrees: -90))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.interactiveSpring(response: 1.5, dampingFraction: 1.5, blendDuration: 0.7).delay(Double(index) * 0.9)) {
                        show = true
                    }
                }
            }
    }
}
