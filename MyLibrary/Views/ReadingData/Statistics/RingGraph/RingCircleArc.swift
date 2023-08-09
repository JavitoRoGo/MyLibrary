//
//  RingCircleArc.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/4/22.
//

import SwiftUI

struct RingCircleArc: View {
    let datas: [Int]
    let colors: [Color]
    
    var body: some View {
        ZStack {
            ForEach(datas.indices, id:\.self) { index in
                MyRing(datas: datas, index: index)
                    .foregroundColor(colors[index])
            }
        }
        .scaleEffect(0.7)
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct RingCircleArc_Previews: PreviewProvider {
    static let datas = [10, 20, 30, 40]
    static let colors: [Color] = [.red, .orange, .blue, .green, .yellow]
    
    static var previews: some View {
        RingCircleArc(datas: datas, colors: colors)
    }
}
