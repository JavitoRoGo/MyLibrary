//
//  ProgressRing.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 6/3/22.
//

import SwiftUI

struct ProgressRing: View {
    let book: NowReading
    @State private var showingRing = false
    @State private var showingReadingTimer = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(AngularGradient(colors: [.red, .orange, .yellow, .green], center: .center, startAngle: Angle.init(degrees: 0), endAngle: Angle.init(degrees: 360)), lineWidth: 15).opacity(0.1)
                .rotationEffect(.init(degrees: -90))
                .overlay {
                    VStack {
                        Text("\(book.progress)%")
                            .font(.system(size: 60))
                        if !book.isFinished {
                            Text(!book.sessions.isEmpty ? "\(book.nextPage - 1) / \(book.lastPage)" : "0 / \(book.lastPage)")
                            if book.isOnReading {
                                NavigationLink(destination: ReadingTimer(book: book)) {
                                    Text("Leer")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            Circle()
                .trim(from: 0, to: showingRing ? CGFloat(book.progress) / 100 : 0)
                .stroke(AngularGradient(colors: [.red, .orange, .yellow, .green], center: .center, startAngle: Angle.init(degrees: 0), endAngle: Angle.init(degrees: 350)),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round, lineJoin: .round)).opacity(book.isOnReading ? 1 : 0.4)
                .rotationEffect(.init(degrees: -90))
        }
        .frame(width: 200, height: 200)
        .padding()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.interactiveSpring(response: 1.5, dampingFraction: 1.5, blendDuration: 1).delay(0.1)) {
                    showingRing = true
                }
            }
        }
        .sheet(isPresented: $showingReadingTimer) {
            NavigationView {
                ReadingTimer(book: book)
            }
        }
    }
}

struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing(book: NowReading.example[0])
    }
}
