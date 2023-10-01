//
//  ModelData.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/2/23.
//

import Foundation
import CoreLocation

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

struct Books: Codable, Identifiable, Equatable, BooksProtocol {
    let id: Int
    let author: String
    var bookTitle: String
    let originalTitle: String
    let publisher: String
    let city: String
    let edition: Int
    let editionYear: Int
    let writingYear: Int
    let coverType: Cover
    let isbn1: Int
    let isbn2: Int
    let isbn3: Int
    let isbn4: Int
    let isbn5: Int
    let pages: Int
    let height: Double
    let width: Double
    let thickness: Double
    let weight: Int
    let price: Double
    var place: String
    var owner: String
    var status: ReadingStatus
    var isActive: Bool
    var synopsis: String?
	var cover: String? = nil
}

struct EBooks: Codable, Identifiable, Equatable, BooksProtocol {
    let id: Int
    let author: String
    let bookTitle: String
    let originalTitle: String
    let year: Int
    let pages: Int
    let price: Double
    var owner: String
    var status: ReadingStatus
    var synopsis: String? = nil
	var cover: String? = nil
}

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

struct RDLocation: Codable, Equatable, Identifiable {
    let id: UUID
    let latitude: Double
    let longitude: Double
}

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
    var pages: Int {
        lastPage - firstPage + 1
    }
    var nextPage: Int {
        guard let lastRead = sessions.first?.endingPage else { return firstPage }
        if lastRead < lastPage {
            return lastRead + 1
        } else {
            return lastPage
        }
    }
    var progress: Int {
        guard let lastRead = sessions.first?.endingPage else { return 0 }
        let percent = lastRead * 100 / (lastPage - firstPage + 1)
        if percent <= 100 {
            return percent
        } else {
            return 100
        }
    }
    var readingTime: String {
        guard !sessions.isEmpty else { return "-" }
        let duration = sessions.reduce(0) { $0 + $1.readingTimeInHours }
		return duration.minPerDayDoubleToString
    }
    var minPerPag: String {
        guard !sessions.isEmpty else { return "-" }
        let sum = sessions.reduce(0) { $0 + $1.minPerPagSessionInMinutes }
        let mean = sum / Double(sessions.count)
		return mean.minPerPagDoubleToString
    }
    var minPerDay: String {
        guard !sessions.isEmpty else { return "-" }
        let sum = sessions.reduce(0) { $0 + $1.readingTimeInHours }
        let mean = sum / Double(sessions.count)
		return mean.minPerDayDoubleToString
    }
    var pagesPerDay: Int {
        guard !sessions.isEmpty else { return 0 }
        let sum = sessions.reduce(0) { $0 + $1.pages }
        let mean = sum / sessions.count
        return mean
    }
    var remainingPages: Int {
        lastPage - nextPage + 1
    }
    
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
    var pages: Int {
        endingPage - startingPage + 1
    }
    
    var readingTimeInHours: Double {
		duration.minPerDayInHours
    }
    
    var minPerPagSessionInMinutes: Double {
		minPerPag.minPerPagInMinutes
    }
}

struct Quote: Codable, Equatable {
    let date: Date
    let bookTitle: String
    let page: Int
    let text: String
}


// Protocolo al que conformar para usar genéricos en algunas funciones, para Books y EBooks
protocol BooksProtocol {
	var pages: Int { get }
	var price: Double { get }
	var status: ReadingStatus { get set }
}


let soldText = "Vendido"
let donatedText = "Donado"
