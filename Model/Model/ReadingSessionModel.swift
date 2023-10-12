//
//  ReadingSessionModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Reading session type. A struct used to contain a reading session, each period of time the user reads.
/// Some properties that describes a session are date, duration and so on. All the properties are required and have to be initialised, with the exception of comment and quotes that can be nil.
struct ReadingSession: Codable, Identifiable, Equatable {
	let id: UUID
	var date: Date
	var duration: String
	var startingPage: Int
	var endingPage: Int
	var minPerPag: String
	var comment: Quote? = nil
	var quotes: [Quote]? = nil
}

extension ReadingSession {
	/// A ReadingSession type computed property used to get the number of pages read in each reading session.
	var pages: Int {
		endingPage - startingPage + 1
	}
	
	/// A ReadingSession type computed property used to get the duration of each reading session as a Double.
	var readingTimeInHours: Double {
		duration.minPerDayInHours
	}
	
	/// A ReadingSession type computed property used to get the minutes needed for reading a whole page as a Double.
	var minPerPagSessionInMinutes: Double {
		minPerPag.minPerPagInMinutes
	}
}
