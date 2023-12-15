//
//  ReadingSessionModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Reading session type.
///
/// A struct used to contain a reading session, each period of time the user reads.
/// Some properties that describes a session are date, duration and so on.
/// All the properties are required and have to be initialised, with the exception of comment and quotes that can be nil.
struct ReadingSession: Codable, Identifiable, Equatable, Hashable {
	/// An unique identifier for each reading session, generated using UUID init.
	let id: UUID
	/// The date in which the session has taken place.
	var date: Date
	/// A String with format `0h 00min` representing the amount of reading time.
	var duration: String
	/// The first page read in each session.
	var startingPage: Int
	/// The last page read in each session.
	var endingPage: Int
	/// A String representing the time spent in reading a page in each session, with format `0min 00s`.
	var minPerPag: String
	/// A comment or personal opinion given to each session.
	var comment: Quote? = nil
	/// Any quote of interest taken of during the session.
	var quotes: [Quote]? = nil
}

extension ReadingSession {
	/// The number of pages read in each reading session, calculated from ``startingPage`` and ``endingPage``.
	var pages: Int {
		endingPage - startingPage + 1
	}
	
	/// The duration in hours of each reading session as a Double.
	var readingTimeInHours: Double {
		duration.minPerDayInHours
	}
	
	/// The minutes needed for reading a whole page as a Double.
	var minPerPagSessionInMinutes: Double {
		minPerPag.minPerPagInMinutes
	}
}
