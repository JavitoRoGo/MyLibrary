//
//  RSEditExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import Foundation

extension RSEdit {
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
	
	var hasChanged: Bool {
		let newDateChanges: Bool
		if sessionDate != session.date {
			newDateChanges = true
		} else {
			newDateChanges = false
		}
		
		let startingPageChanges: Bool
		if startingPage != session.startingPage {
			startingPageChanges = true
		} else {
			startingPageChanges = false
		}
		
		let endingPageChanges: Bool
		if endingPage != session.endingPage {
			endingPageChanges = true
		} else {
			endingPageChanges = false
		}
		
		let hourChanges: Bool
		if hour != Int(session.readingTimeInHours) {
			hourChanges = true
		} else {
			hourChanges = false
		}
		
		let minuteChanges: Bool
		if minute != Int((session.readingTimeInHours.truncatingRemainder(dividingBy: 1.0)) * 60) {
			minuteChanges = true
		} else {
			minuteChanges = false
		}
		
		let commentChanges: Bool
		if let comment = session.comment {
			if commentText != comment.text {
				commentChanges = true
			} else {
				commentChanges = false
			}
		} else {
			if !commentText.isEmpty {
				commentChanges = true
			} else {
				commentChanges = false
			}
		}
		
		let quotesChanges: Bool
		if let quotes = session.quotes {
			if self.quotes != quotes {
				quotesChanges = true
			} else {
				quotesChanges = false
			}
		} else {
			quotesChanges = false
		}
		
		if newDateChanges || startingPageChanges || endingPageChanges || hourChanges || minuteChanges || commentChanges || quotesChanges {
			return true
		}
		return false
	}
	
	func loadSessionData() {
		sessionDate = session.date
		startingPage = session.startingPage
		endingPage = session.endingPage
		hour = Int(session.readingTimeInHours)
		minute = Int((session.readingTimeInHours.truncatingRemainder(dividingBy: 1.0)) * 60)
		if let comment = session.comment {
			commentText = comment.text
			addingComment = true
		}
		if let quotes = session.quotes {
			self.quotes = quotes
		}
	}
	
	func modifySession() {
		guard let index = nrmodel.readingList.firstIndex(of: book) else { return }
		if endingPage >= book.lastPage {
			endingPage = book.lastPage
			nrmodel.readingList[index].isFinished = true
		}
		let newDate: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: sessionDate) ?? .now
		session = ReadingSession(id: session.id, date: newDate, duration: sessionDuration, startingPage: startingPage, endingPage: endingPage, minPerPag: minPerPag)
		if !commentText.isEmpty {
			session.comment = Quote(date: sessionDate, bookTitle: book.bookTitle, page: 0, text: commentText)
		}
		if !quotes.isEmpty {
			session.quotes = quotes
		}
		if let bookSessionIndex = nrmodel.readingList[index].sessions.firstIndex(where: { $0.id == session.id }),
		   let sessionIndex = rsmodel.readingSessionList.firstIndex(where: { $0.id == session.id }) {
			nrmodel.readingList[index].sessions[bookSessionIndex] = session
			rsmodel.readingSessionList[sessionIndex] = session
		}
	}
}
