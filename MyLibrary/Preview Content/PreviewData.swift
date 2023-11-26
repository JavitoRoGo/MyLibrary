//
//  PreviewData.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/9/23.
//

import Foundation

// dataTest para los structs del modelo

extension User {
	static let dataTest = User(id: UUID(), username: "email@noemail.com", password: "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8", nickname: "Nick", books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
	static let emptyUser = User(id: UUID(), username: "", password: "", nickname: "", books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
}

extension Books {
	static let dataTest = Books(id: 0, author: "Pepito Pérez", bookTitle: "Título de libro", originalTitle: "Título original", publisher: "Editorial", city: "Ciudad", edition: 1, editionYear: 2021, writingYear: 2021, coverType: .pocket, isbn1: 9, isbn2: 9, isbn3: 9, isbn4: 9, isbn5: 9, pages: 999, height: 9.9, width: 9.9, thickness: 9.9, weight: 666, price: 6.66, place: "LP", owner: "Javi", status: .consulting, isActive: true, cover: "azuldeprusia")
}

extension EBooks {
	static let dataTest = EBooks(id: 0, author: "Pepito Pérez", bookTitle: "Título del ebook", originalTitle: "Título original", year: 2022, pages: 666, price: 9.99, owner: "Yo", status: .consulting, synopsis: "Resumen de prueba.", cover: "headhunters")
}

extension ReadingData {
	static let dataTest = ReadingData(id: 0, yearId: 0, bookTitle: "Título del libro", startDate: Date.distantPast, finishDate: Date.distantFuture, finishedInYear: 2019, sessions: 99, duration: "10h 10min", pages: 666, over50: 99, minPerPag: "1min 30s", minPerDay: "0h 59min", pagPerDay: 66, percentOver50: 66, formatt: .paper, rating: 3, synopsis: "Resumen del libro", cover: "headhunters", comment: "Comentario de prueba al libro.", location: RDLocation.dataTest, readingSessions: [ReadingSession.dataTest])
}

extension RDLocation {
	static let dataTest = RDLocation(id: UUID(), latitude: 37.795834, longitude: -122.416417)
}

extension NowReading {
	static let dataTest = NowReading(bookTitle: "Libro en lectura", firstPage: 7, lastPage: 444, synopsis: "Resumen del libro", formatt: .paper, isOnReading: true, isFinished: true, sessions: [
			ReadingSession(id: UUID(), date: Date.now, duration: "2h 2min", startingPage: 253, endingPage: 352, minPerPag: "1min 47s"),
			ReadingSession(id: UUID(), date: Date.now, duration: "1h 1min", startingPage: 222, endingPage: 252, minPerPag: "1min 58s")], 
									 comment: "Comentario al libro de prueba.", location: RDLocation.dataTest)
}

extension ReadingSession {
	static let dataTest = ReadingSession(id: UUID(), date: .now, duration: "11min", startingPage: 9, endingPage: 19, minPerPag: "1min 22s", comment: Quote(date: .now, bookTitle: "Título del libro", page: 66, text: "Comentario de sesión de prueba"), quotes: [Quote(date: .now, bookTitle: "Título del libro", page: 69, text: "Cita de prueba.")])
}


// Datos de ejemplo para el widget

let exampleCurrent = TargetForWidget(dailyPages: 20, dailyTime: 1, weeklyPages: 100, weeklyTime: 5, monthlyPages: 1000, monthlyBooks: 2, yearlyPages: 5500, yearlyBooks: 32)
let exampleTarget = TargetForWidget(dailyPages: 40, dailyTime: 2, weeklyPages: 250, weeklyTime: 7, monthlyPages: 1200, monthlyBooks: 4, yearlyPages: 8000, yearlyBooks: 40)
let exampleData = DataForWidget(bookTitle: "Leyendo libro", progress: 55, remaining: 69, sessions: [ReadingSession.dataTest], read: exampleCurrent, targets: exampleTarget)


// Preview

struct PersistencePreview: PersistenceInteractor {
	var bundleURL: URL {
		Bundle.main.url(forResource: "USERPreview", withExtension: "json")!
	}
	
	var docURL: URL {
		URL.documentsDirectory.appending(path: "USERPreview.json")
	}
}

extension GlobalViewModel {
	static let preview = GlobalViewModel(userLogic: UserLogic(persistence: PersistencePreview()))
}
