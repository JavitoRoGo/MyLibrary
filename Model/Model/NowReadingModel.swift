//
//  NowReadingModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// NowReading data type. A struct used to contain each book or ebook which is on both reading status or in waiting list.
/// Some of these properties are book title, starting and finishing page, format and so on. All the properties are required and have to be initialised, with the exception of comment and location that can be nil.
struct NowReading: Codable, Equatable {
	var bookTitle: String
	var firstPage: Int
	var lastPage: Int
	var synopsis: String
	let formatt: Formatt
	var isOnReading: Bool
	var isFinished: Bool
	var sessions: [ReadingSession]
	var comment: String?
	var location: RDLocation?
}

extension NowReading {
	/// A NowReading type computed property use to get the number of total pages to be read as an Int.
	var pages: Int {
		lastPage - firstPage + 1
	}
	
	/// A NowReading type computed property use to get the next page to be read as an Int.
	var nextPage: Int {
		guard let lastRead = sessions.first?.endingPage else { return firstPage }
		if lastRead < lastPage {
			return lastRead + 1
		} else {
			return lastPage
		}
	}
	
	/// A NowReading type computed property use to get the reading progress as a percentage as an Int.
	var progress: Int {
		guard let lastRead = sessions.first?.endingPage else { return 0 }
		let percent = lastRead * 100 / (lastPage - firstPage + 1)
		if percent <= 100 {
			return percent
		} else {
			return 100
		}
	}
	
	/// A NowReading type computed property use to get the total time spent in reading each book as a String.
	var readingTime: String {
		guard !sessions.isEmpty else { return "-" }
		let duration = sessions.reduce(0) { $0 + $1.readingTimeInHours }
		return duration.minPerDayDoubleToString
	}
	
	/// A NowReading type computed property use to get the mean value of time in minutes spent to read a page as a String.
	var minPerPag: String {
		guard !sessions.isEmpty else { return "-" }
		let sum = sessions.reduce(0) { $0 + $1.minPerPagSessionInMinutes }
		let mean = sum / Double(sessions.count)
		return mean.minPerPagDoubleToString
	}
	
	/// A NowReading type computed property use to get the mean value of reading time spent each day as a String.
	var minPerDay: String {
		guard !sessions.isEmpty else { return "-" }
		let sum = sessions.reduce(0) { $0 + $1.readingTimeInHours }
		let mean = sum / Double(sessions.count)
		return mean.minPerDayDoubleToString
	}
	
	/// A NowReading type computed property use to get the mean value of the number of pages read each day as an Int.
	var pagesPerDay: Int {
		guard !sessions.isEmpty else { return 0 }
		let sum = sessions.reduce(0) { $0 + $1.pages }
		let mean = sum / sessions.count
		return mean
	}
	
	/// A NowReading type computed property use to get the number of pages left to finish the book as an Int.
	var remainingPages: Int {
		lastPage - nextPage + 1
	}
	
	/// A NowReading type computed property use to get the time in hours left to finish the book as a Double.
	var remainingTime: Double {
		var timeLeft = 0.0
		if minPerPag.isEmpty || minPerPag == "-" {
#if os(iOS)
			timeLeft = GlobalViewModel().userLogic.meanMinPerPag * Double(remainingPages) / 60.0
#elseif os(watchOS)
			timeLeft = Double(remainingPages * 2)
#endif
		} else {
			timeLeft = minPerPag.minPerPagInMinutes * Double(remainingPages) / 60.0
		}
		return timeLeft
	}
	
	/// A NowReading type computed property use to get
	var finishingDay: Date {
		guard let lastReadingDay = sessions.first?.date else {
#if os(iOS)
			let daysLeft = Double(remainingPages) / GlobalViewModel().userLogic.meanPagPerDay
#elseif os(watchOS)
			let daysLeft = Double(remainingPages) / Double(40)
#endif
			let secondsLeft = daysLeft * 24 * 3600
			let finishIn = Date.now.addingTimeInterval(secondsLeft)
			return finishIn
		}
		let daysLeft = Double(remainingPages) / Double(pagesPerDay)
		let secondsLeft = daysLeft * 24 * 3600
		let finishIn = lastReadingDay.addingTimeInterval(secondsLeft)
		return finishIn
	}
}
