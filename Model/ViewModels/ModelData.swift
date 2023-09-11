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
	
	static let example = User(id: UUID(), username: "email@noemail.com", nickname: "Nick", books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
	static let emptyUser = User(id: UUID(), username: "", nickname: "", books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
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
    
    static let dataTest = Books(id: 0, author: "Pepito Pérez", bookTitle: "Título de libro", originalTitle: "Título original", publisher: "Editorial", city: "Ciudad", edition: 1, editionYear: 2021, writingYear: 2021, coverType: .pocket, isbn1: 9, isbn2: 9, isbn3: 9, isbn4: 9, isbn5: 9, pages: 999, height: 9.9, width: 9.9, thickness: 9.9, weight: 666, price: 6.66, place: "LP", owner: "Javi", status: .consulting, isActive: true)
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
    
    static let dataTest = EBooks(id: 0, author: "Pepito Pérez", bookTitle: "Título del ebook", originalTitle: "Título original", year: 2022, pages: 666, price: 9.99, owner: "Yo", status: .consulting, synopsis: "Resumen de prueba.")
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
    
    static let dataTest = ReadingData(id: 0, yearId: 0, bookTitle: "Título del libro", startDate: Date.distantPast, finishDate: Date.distantFuture, finishedInYear: 2019, sessions: 99, duration: "10h 10min", pages: 666, over50: 99, minPerPag: "1min 30s", minPerDay: "0h 59min", pagPerDay: 66, percentOver50: 66, formatt: .paper, rating: 3, synopsis: "Resumen del libro", cover: "cover001", comment: "Comentario de prueba al libro.", location: RDLocation.dataTest, readingSessions: [ReadingSession.example])
}

struct RDLocation: Codable, Equatable, Identifiable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    
    static let dataTest = RDLocation(id: UUID(), latitude: 37.795834, longitude: -122.416417)
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
            timeLeft = UserViewModel().meanMinPerPag * Double(remainingPages) / 60.0
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
            let daysLeft = Double(remainingPages) / UserViewModel().meanPagPerDay
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

extension NowReading {
    static let example = [
        NowReading(bookTitle: "Libro en lectura", firstPage: 7, lastPage: 444, synopsis: "Resumen del libro", formatt: .paper, isOnReading: true, isFinished: true, sessions: [
                   ReadingSession(id: UUID(), date: Date.now, duration: "2h 2min", startingPage: 253, endingPage: 352, minPerPag: "1min 47s"),
                   ReadingSession(id: UUID(), date: Date.now, duration: "1h 1min", startingPage: 222, endingPage: 252, minPerPag: "1min 58s")], comment: "Comentario al libro de prueba.", location: RDLocation.dataTest),
        NowReading(bookTitle: "Libro en espera1", firstPage: 7, lastPage: 544, synopsis: "Resumen en espera", formatt: .paper, isOnReading: false, isFinished: false, sessions: []),
        NowReading(bookTitle: "Libro en espera2", firstPage: 7, lastPage: 544, synopsis: "Resumen en espera", formatt: .kindle, isOnReading: false, isFinished: false, sessions: []),
        NowReading(bookTitle: "Libro terminado", firstPage: 7, lastPage: 144, synopsis: "Resumen de libro terminado", formatt: .kindle, isOnReading: false, isFinished: true, sessions: [ReadingSession(id: UUID(), date: Date.now, duration: "2h 2min", startingPage: 7, endingPage: 144, minPerPag: "1min 47s")])
    ]
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
    
    static let example = ReadingSession(id: UUID(), date: .now, duration: "11min", startingPage: 9, endingPage: 19, minPerPag: "1min 22s", comment: Quote(date: .now, bookTitle: "Título del libro", page: 66, text: "Comentario de sesión de prueba"), quotes: [Quote(date: .now, bookTitle: "Título del libro", page: 69, text: "Cita de prueba.")])
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
