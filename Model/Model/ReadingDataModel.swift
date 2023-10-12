//
//  ReadingDataModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Reading data type. A struct used to contain a book or ebook that has been read and finished.
/// Some of these properties are book title, starting and finishing date, duration, rating and so on. All the properties are required and have to be initialised, with the exception of comment and location that can be nil.
struct ReadingData: Codable, Identifiable, Equatable {
	let id: Int
	let yearId: Int
	let bookTitle: String
	let startDate: Date
	let finishDate: Date
	let finishedInYear: Int
	let sessions: Int
	let duration: String
	let pages: Int
	let over50: Int
	let minPerPag: String
	let minPerDay: String
	let pagPerDay: Double
	let percentOver50: Double
	let formatt: Formatt
	var rating: Int
	let synopsis: String
	let cover: String
	var comment: String? = nil
	var location: RDLocation? = nil
	var readingSessions: [ReadingSession]
}
