//
//  TimerView.swift
//  MyLibraryForWatch Watch App
//
//  Created by Javier Rodríguez Gómez on 2/2/23.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject var wcmodel = ConnectivityMaganer()
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.dismiss) var dismiss
    
    @Binding var book: NowReading
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var seconds: Int = 0
    @State private var totalSeconds: Int = 0
    
    @State private var showingSavingAlert = false
    @State private var timerIsRunning = false
    @State private var timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var lastDateObserved: Date = Date()
        
    var body: some View {
        NavigationStack {
            Text("\(hours < 10 ? "0\(hours)" : "\(hours)"):\(minutes < 10 ? "0\(minutes)" : "\(minutes)"):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
                .font(.largeTitle)
            HStack(spacing: 20) {
                Button {
                    timerIsRunning = false
                    let minutesRead = hours * 60 + minutes + (seconds >= 30 ? 1 : 0)
                    wcmodel.session.sendMessage(["timeRead" : minutesRead], replyHandler: nil) { error in
                        print(error.localizedDescription)
                    }
                    showingSavingAlert = true
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.red.opacity(0.7))
                        .overlay {
                            VStack(spacing: 5) {
                                Image(systemName: "stop.fill")
                                    .font(.title2)
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 70, height: 70)
                }
                Button {
                    timerIsRunning.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.green.opacity(0.8))
                        .overlay {
                            VStack(spacing: 5) {
                                Image(systemName: timerIsRunning ? "pause.fill" : "play.fill")
                                    .font(.title2)
                            }
                            .foregroundColor(.white)
                        }
                        .frame(width: 70, height: 70)
                }
            }
            .buttonStyle(.plain)
        }
        .alert("Tiempo de lectura guardado.", isPresented: $showingSavingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Termina de registrar la sesión de lectura en el iPhone.")
        }
        .onAppear {
            timerIsRunning = true
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

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(book: .constant(NowReading.dataTest))
    }
}
