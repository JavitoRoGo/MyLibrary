//
//  RingTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct RingTargetView: View {
    let color: Color
    let current: Int
    let target: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color, lineWidth: 10).opacity(0.1)
            Circle()
                .trim(from: 0, to: CGFloat(current) / CGFloat(target))
                .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
    }
}

struct RingTargetView_Previews: PreviewProvider {
    static var previews: some View {
        RingTargetView(color: .red, current: 15, target: 40)
            .environmentObject(UserViewModel())
    }
}
