//
//  ReadingTimer.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/4/22.
//

import SwiftUI

struct ReadingTimer: View {
    @EnvironmentObject var rsmodel: ReadingSessionModel
    @Environment(\.scenePhase) var scenePhase
    
    @State var book: NowReading
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var totalSeconds: Int = 0
    
    @State private var timerIsRunning = false
    @State private var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var lastDateObserved: Date = Date()
    
    @State private var showingAddSession = false
    @State private var showingAddQuote = false
    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    timerIsRunning = false
                    showingAddQuote = true
                } label: {
                    Image(systemName: "quote.bubble")
                }
            }
        }
        .sheet(isPresented: $showingAddSession) {
            NavigationView {
                AddRS(book: $book, startingPage: book.nextPage, hour: hours, minute: seconds >= 30 ? minutes + 1 : minutes)
            }
        }
        .sheet(isPresented: $showingAddQuote) {
            AddQuoteView(bookTitle: book.bookTitle)
        }
        .onAppear {
            timerIsRunning = true
            rsmodel.tempQuotesArray.removeAll()
        }
        .onReceive(timer) { _ in
            if timerIsRunning {
                if seconds == 59 {
                    seconds = 0
                    if minutes == 59 {
                        minutes = 0
                        hours += 1
                    } else {
                        minutes += 1
                    }
                } else {
                    seconds += 1
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if timerIsRunning {
                if phase == .background {
                    totalSeconds = hours * 3600 + minutes * 60 + seconds
                    lastDateObserved = .now
                }
                if phase == .active {
                    let accumulatedTime = Date().timeIntervalSince(lastDateObserved)
                    totalSeconds += Int(accumulatedTime)
                    hours = totalSeconds / 3600
                    minutes = (totalSeconds / 60) % 60
                    seconds = totalSeconds % 60
                }
            }
        }
    }
}

struct ReadingTimer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReadingTimer(book: NowReading.example[0])
                .environmentObject(ReadingSessionModel())
        }
    }
}
