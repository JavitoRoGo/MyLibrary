//
//  ReadingDataModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Reading data type.
///
/// A struct used to contain a book or ebook that has been read and finished.
/// Some of these properties are book title, starting and finishing date, duration, rating and so on.
/// All the properties are required and have to be initialised, with the exception of comment and location that can be nil.
struct ReadingData: Codable, Identifiable, Equatable {
	/// An unique identifier for each book. It's a consecutive number generated when creating a new instance of ``ReadingData``.
	let id: Int
	/// A consecutive number representing the order or position of each book related to others read in the same year. It is set to 1 when a year turns into new one.
	let yearId: Int
	/// The book title as it is in user's language.
	let bookTitle: String
	/// Date of starting day, the day when the book started to be read.
	let startDate: Date
	/// Date of finishing day, the day when the book is finished.
	let finishDate: Date
	/// A number representing the year of ``finishDate``.
	let finishedInYear: Int
	/// A number representing how many days or reading sessions it took to finish the book.
	let sessions: Int
	/// A String with format `0h 00min` representing the amount of time it took to finish the book.
	let duration: String
	/// Number of pages that were read, NOT the total pages of the book.
	let pages: Int
	/// Number of sessions with 50 or more pages read. Maybe in future versions it could be selected by the user.
	let over50: Int
	/// A String representing the mean value of time spent in reading a page, with format `0min 00s`.
	let minPerPag: String
	/// A String representing the mean value of time spent reading every session.
	let minPerDay: String
	/// The mean value of pages read every session.
	let pagPerDay: Double
	/// The percentage of session with pages >= 50 versus the total number of sessions.
	let percentOver50: Double
	/// The format or type of the book. Choose between a paper book or an ebook.
	let formatt: Formatt
	/// The rating given by the user, going from 1 to 5 in star scale format.
	var rating: Int
	/// The synopsis of the book.
	let synopsis: String
	/// It contains the file name of the image that represents the book. It is set using ``imageCoverName(from:)`` function from `bookTitle`.
	///
	/// ```swift
	/// rdata.cover = imageCoverName(from: rdata.bookTitle)
	/// ```
	let cover: String
	/// The comment or personal opinion given to the book by the user.
	var comment: String? = nil
	/// The location where the book was read or finished, in lat-long format.
	var location: RDLocation? = nil
	/// It contains the information for all the reading sessions.
	var readingSessions: [ReadingSession]
}
