//
//  PreviewData.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/9/23.
//

import Foundation

// dataTest para los structs del modelo

extension User {
	static let emptyUser = User(id: UUID(), username: "", password: "", nickname: "", books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
}

extension Books {
	static let example = GlobalViewModel.preview.userLogic.user.books
}

extension EBooks {
	static let example = GlobalViewModel.preview.userLogic.user.ebooks
}

extension ReadingData {
	static let example = GlobalViewModel.preview.userLogic.user.readingDatas
}

extension RDLocation {
	static let example = RDLocation(id: UUID(), latitude: 37.795834, longitude: -122.416417)
}

extension NowReading {
	static let example = GlobalViewModel.preview.userLogic.user.nowReading
}

extension ReadingSession {
	static let example = GlobalViewModel.preview.userLogic.user.sessions
}


// Datos de ejemplo para el widget

let exampleCurrent = TargetForWidget(dailyPages: 20, dailyTime: 1, weeklyPages: 100, weeklyTime: 5, monthlyPages: 1000, monthlyBooks: 2, yearlyPages: 5500, yearlyBooks: 32)
let exampleTarget = TargetForWidget(dailyPages: 40, dailyTime: 2, weeklyPages: 250, weeklyTime: 7, monthlyPages: 1200, monthlyBooks: 4, yearlyPages: 8000, yearlyBooks: 40)
let exampleData = DataForWidget(bookTitle: "Leyendo libro", progress: 55, remaining: 69, sessions: ReadingSession.example, read: exampleCurrent, targets: exampleTarget)


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
	static let preview = GlobalViewModel(userLogic: UserLogic.test)
}
