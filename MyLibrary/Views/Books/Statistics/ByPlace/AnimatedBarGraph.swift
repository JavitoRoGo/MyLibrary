//
//  AnimatedBarGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/4/22.
//

import SwiftUI

struct AnimatedBarGraph: View {
    let index: Int
    let showOver50: Bool
    @State private var showBar = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(showOver50 ? LinearGradient(colors: [.red, .blue, .green, .yellow], startPoint: .leading, endPoint: .trailing) :
                LinearGradient(colors: [.blue, .green, .yellow], startPoint: .leading, endPoint: .trailing)
            )
            .frame(height: 15)
            .frame(width: showBar ? nil : 0, alignment: .leading)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeInOut(duration: 0.8).delay(Double(index) * 0.1)) {
                        showBar = true
                    }
                }
            }
    }
}

struct AnimatedBarGraph_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedBarGraph(index: 0, showOver50: false)
    }
}
