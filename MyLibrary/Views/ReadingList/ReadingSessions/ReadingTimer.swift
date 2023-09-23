//
//  ReadingTimer.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/4/22.
//

import SwiftUI

struct ReadingTimer: View {
    @EnvironmentObject var rsmodel: GlobalViewModel
    @Environment(\.scenePhase) var scenePhase
    
    @State var book: NowReading
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var totalSeconds: Int = 0
    
    @State var timerIsRunning = false
    @State var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State var lastDateObserved: Date = Date()
    
    @State var showingAddSession = false
    @State var showingAddQuote = false
    
    var body: some View {
        VStack {
            Text("\(hours < 10 ? "0\(hours)" : "\(hours)"):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
                .font(.system(size: 80))
                .padding(.top, 60)
            Text(book.bookTitle)
                .font(.title2)
                .padding(.top)
            Divider()
            HStack {
                Text("Leyendo desde la página...")
                Spacer()
                Text(book.nextPage, format: .number)
            }
            .padding(.top, 30)
            .padding(.horizontal)
            Spacer()
            HStack {
                Spacer()
                Button {
                    timerIsRunning = false
                    showingAddSession = true
                } label: {
                    Capsule()
                        .fill(.red.opacity(0.7))
                        .overlay {
                            VStack(spacing: 5) {
                                Image(systemName: "stop.fill")
                                    .font(.title)
                                Text("Terminar")
                                    .font(.body.bold())
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 75)
                }
                Spacer()
                Button {
                    timerIsRunning.toggle()
                } label: {
                    Capsule()
                        .fill(.green.opacity(0.8))
                        .overlay {
                            VStack(spacing: 5) {
                                Image(systemName: timerIsRunning ? "pause.fill" : "play.fill")
                                    .font(.title)
                                Text(timerIsRunning ? "Pausa" : "Leer")
                                    .font(.body.bold())
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 75)
                }
                Spacer()
            }
            Spacer()
        }
		.modifier(ReadingTimerModifier(book: $book, hours: $hours, minutes: $minutes, seconds: $seconds, totalSeconds: $totalSeconds, timerIsRunning: $timerIsRunning, timer: $timer, lastDateObserved: $lastDateObserved, showingAddSession: $showingAddSession, showingAddQuote: $showingAddQuote))
    }
}

struct ReadingTimer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReadingTimer(book: NowReading.dataTest)
				.environmentObject(GlobalViewModel.preview)
        }
    }
}
