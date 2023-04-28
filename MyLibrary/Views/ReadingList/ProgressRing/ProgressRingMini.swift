//
//  ProgressRingMini.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/3/22.
//

import SwiftUI

struct ProgressRingMini: View {
    let book: NowReading
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(book.isOnReading ? (book.progress > 75 ? .green : book.progress > 50 ? .yellow : book.progress > 25 ? .orange : .red) : .gray, lineWidth: 3).opacity(0.1)
                .overlay {
                    Text("\(book.progress)%")
                }
            Circle()
                .trim(from: 0, to: CGFloat(book.progress) / 100)
                .stroke(book.isOnReading ? (book.progress > 75 ? .green : book.progress > 50 ? .yellow : book.progress > 25 ? .orange : .red) : .gray.opacity(0.8),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
        }
        .frame(width: 50, height: 50)
    }
}

struct ProgressRingMini_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingMini(book: NowReading.example[0])
    }
}
