//
//  UserModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/2/23.
//

import Foundation

/// User data type, the main data.
///
/// It contains the rest of other datas, such as ``Books``, ``EBooks``, ``ReadingData`` and more. All the properties are required and have to be initialised, as empty if needed.
struct User: Identifiable, Codable {
	/// An unique identifier for each user, generated using UUID init.
    var id: UUID
	/// The username in email format used to get access.
    var username: String
	/// The nickname that is shown on `LockScreenView` and `UserMainView`.
    var nickname: String
	/// A property to store all the ``Books`` items.
    var books: [Books]
	/// A property to store all the ``EBooks`` items.
    var ebooks: [EBooks]
	/// A property to store all the ``ReadingData`` items.
    var readingDatas: [ReadingData]
	/// A property to store all the ``NowReading`` items that are on reading status.
    var nowReading: [NowReading]
	/// A property to store all the ``NowReading`` items that are on waiting list.
    var nowWaiting: [NowReading]
	/// A property to store all the ``ReadingSession`` items.
    var sessions: [ReadingSession]
	/// A property to store the places created by the user where to locate the ``Books`` items.
    var myPlaces: [String]
	/// A property to store a list of people who are the owner of each ``Books`` or ``EBooks``.
	var myOwners: [String]
}

extension User {
	/// An array of unique years in which each session was read, to lately get a list of books finished in each year.
	var bookFinishingYears: [Int] {
		var years = [Int]()
		sessions.forEach { session in
			let year = Calendar.current.component(.year, from: session.date)
			years.append(year)
		}
		
		return years.uniqued().sorted()
	}
}

extension User {
	/// Merging imported data from outside the app with existing data.
	///
	/// This method adds the new data to existing data, such as books, ebooks and more.
	/// But for the case of Places and Owners, it adds only those that doesn't previously exist.
	///
	/// ```swift
	/// let newData = try JSONDecoder().decode(User.self, from: data)
	/// User.merge(newData)
	/// ```
	///
	/// - Parameter other: The data to add or merge to existing User data.
	mutating func merge(_ other: User) {
		self.books += other.books
		self.ebooks += other.ebooks
		self.readingDatas += other.readingDatas
		self.nowReading += other.nowReading
		self.nowWaiting += other.nowWaiting
		self.sessions += other.sessions
		
		// Añadir los que no se repiten
		for place in other.myPlaces where !self.myPlaces.contains(place) {
			self.myPlaces.append(place)
		}
		for owner in other.myOwners where !self.myOwners.contains(owner) {
			self.myOwners.append(owner)
		}
	}
}
