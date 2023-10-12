//
//  UserModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/2/23.
//

import Foundation

/// User data type, the main data. It contains the rest of other datas, such as books, ebooks, readingDatas and more. All the properties are required and have to be initialised, as empty if needed.
struct User: Identifiable, Codable {
    var id: UUID
    var username: String
    var nickname: String
    var books: [Books]
    var ebooks: [EBooks]
    var readingDatas: [ReadingData]
    var nowReading: [NowReading]
    var nowWaiting: [NowReading]
    var sessions: [ReadingSession]
    var myPlaces: [String]
	var myOwners: [String]
}

extension User {
	/// A User type computed property. Getting an array of unique years in which each session was read, to lately get a list of books finished in each year.
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
	/// A User type function used to merge imported data with existing one. It adds to existing data the new one, such as books, ebooks and more.
	/// But for the case of Places and Owners, it adds only those that doesn't previously exist.
	/// - Parameter other: The User data to add or merge to existing User data.
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
