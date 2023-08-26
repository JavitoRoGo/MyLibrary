//
//  AddRSExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension AddRS {
	var sessionDuration: String {
		return "\(hour)h \(minute)min"
	}
	var minPerPag: String {
		let valueInMinutes = durationInMinutes / Double(endingPage - startingPage + 1)
		let float = valueInMinutes.truncatingRemainder(dividingBy: 1.0)
		let min = Int(valueInMinutes - float)
		let sec = Int(round(float * 60))
		return "\(min)min \(sec)s"
	}
	var durationInMinutes: Double {
		Double(hour * 60 + minute)
	}
	
	var isDisabled: Bool {
		guard startingPage == 0 || endingPage == 0 || startingPage > endingPage ||
				(hour == 0 && minute == 0) else { return false }
		return true
	}
	
	func addSession() {
		guard let index = model.user.nowReading.firstIndex(of: book) else { return }
		if endingPage >= book.lastPage {
			endingPage = book.lastPage
			model.user.nowReading[index].isFinished = true
		}
		let newDate: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: sessionDate) ?? .now
		var newSession = ReadingSession(id: UUID(), date: newDate, duration: sessionDuration, startingPage: startingPage, endingPage: endingPage, minPerPag: minPerPag)
		if !commentText.isEmpty {
			newSession.comment = Quote(date: sessionDate, bookTitle: book.bookTitle, page: 0, text: commentText)
		}
		if !model.tempQuotesArray.isEmpty {
			newSession.quotes = model.tempQuotesArray
			model.tempQuotesArray.removeAll()
		}
		model.user.nowReading[index].sessions.insert(newSession, at: 0)
		model.user.sessions.insert(newSession, at: 0)
		
		if Calendar.current.component(.weekday, from: newDate) == 7 {
			let weekPages = model.calcTotalPagesPerWeekAndMonth(tag: 0).pages.reduce(0,+)
			let weekSessions = model.getSessions(tag: 0)
			let weekTime = weekSessions.reduce(0) { $0 + $1.readingTimeInHours }
			if weekPages >= model.weeklyPagesTarget || weekTime >= model.weeklyTimeTarget {
				showingWeeklyAchivedAlert = true
			}
		}
		if newSession.pages >= model.dailyPagesTarget || newSession.readingTimeInHours >= model.dailyTimeTarget {
			showingDailyAchivedAlert = true
		} else {
			dismiss()
		}
	}
	
	struct AddRSModifier: ViewModifier {
		@ObservedObject var wcmodel = ConnectivityMaganer()
		@Environment(\.dismiss) var dismiss
		
		@Binding var book: NowReading
		@Binding var hour: Int
		@Binding var minute: Int
		@Binding var existingTime: Int
		@Binding var showingDailyAchivedAlert: Bool
		@Binding var showingWeeklyAchivedAlert: Bool
		@Binding var showingExistingTimeAlert: Bool
		
		let isDisabled: Bool
		let addSession: () -> Void
		
		func body(content: Content) -> some View {
			content
				.navigationTitle(book.bookTitle)
				.navigationBarTitleDisplayMode(.inline)
				.alert("¡Enhorabuena!", isPresented: $showingDailyAchivedAlert) {
					Button("OK") { dismiss() }
				} message: {
					Text("Has alcanzado tu objetivo diario de lectura.")
				}
				.alert("¡Enhorabuena!", isPresented: $showingWeeklyAchivedAlert) {
					Button("OK") { dismiss() }
				} message: {
					Text("Has alcanzado tu objetivo semanal de lectura.")
				}
				.alert("Existe una sesión iniciada en tu AppleWatch.", isPresented: $showingExistingTimeAlert) {
					Button("Descartar", role: .cancel) {
						wcmodel.readingTime = 0
					}
					Button("Añadir") {
						hour += existingTime / 60
						minute += existingTime % 60
						wcmodel.readingTime = 0
					}
				} message: {
					Text("¿Deseas sumar la duración de esa sesión?")
				}
				.onAppear {
					existingTime = wcmodel.readingTime
					if existingTime != 0 {
						showingExistingTimeAlert = true
					}
				}
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancelar") {
							dismiss()
						}
					}
					ToolbarItem(placement: .confirmationAction) {
						Button("Añadir") {
							addSession()
						}
						.disabled(isDisabled)
					}
				}
		}
	}
}
