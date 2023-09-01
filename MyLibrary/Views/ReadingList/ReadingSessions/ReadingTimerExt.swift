//
//  ReadingTimerExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import Combine
import SwiftUI

extension ReadingTimer {
	struct ReadingTimerModifier: ViewModifier {
		@EnvironmentObject var rsmodel: UserViewModel
		@Environment(\.scenePhase) var scenePhase
		
		@Binding var book: NowReading
		@Binding var hours: Int
		@Binding var minutes: Int
		@Binding var seconds: Int
		@Binding var totalSeconds: Int
		
		@Binding var timerIsRunning: Bool
		@Binding var timer: Publishers.Autoconnect<Timer.TimerPublisher>
		@Binding var lastDateObserved: Date
		
		@Binding var showingAddSession: Bool
		@Binding var showingAddQuote: Bool
		
		func body(content: Content) -> some View {
			content
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
}
