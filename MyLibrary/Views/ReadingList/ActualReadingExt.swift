//
//  ActualReadingExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/8/23.
//

import SwiftUI

extension ActualReading {
	func deleteBook(_ book: NowReading) {
		if book.sessions.isEmpty == false {
			showingDeletingAlert = true
		} else {
			model.removeFromWaiting(book)
			changeToNotRead(book)
		}
	}
	
	func changeToReading(_ book: NowReading) {
		if book.formatt == .paper {
			if let index = BooksModel().books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				bmodel.books[index].status = .reading
			}
		} else {
			if let index = EbooksModel().ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				emodel.ebooks[index].status = .reading
			}
		}
	}
	
	func changeToWaiting(_ book: NowReading) {
		if book.formatt == .paper {
			if let index = BooksModel().books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				BooksModel().books[index].status = .waiting
			}
		} else {
			if let index = EbooksModel().ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				EbooksModel().ebooks[index].status = .waiting
			}
		}
	}
	
	func changeToNotRead(_ book: NowReading) {
		if book.formatt == .paper {
			if let index = bmodel.books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				bmodel.books[index].status = .notRead
			}
		} else {
			if let index = emodel.ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				emodel.ebooks[index].status = .notRead
			}
		}
	}
	
	func shareButton() {
		let userUrl = getURLToShare(from: userJson)
		let booksUrl = getURLToShare(from: booksJson)
		let ebooksUrl = getURLToShare(from: ebooksJson)
		let readingDataUrl = getURLToShare(from: readingDataJson)
		let nowReadingUrl = getURLToShare(from: nowReadingJson)
		let nowWaitingUrl = getURLToShare(from: nowWaitingJson)
		let readingSessionsUrl = getURLToShare(from: readingSessionsJson)
		let myPlacesUrl = getURLToShare(from: myPlacesJson)
		let urls = [userUrl, booksUrl, ebooksUrl, readingDataUrl, nowReadingUrl, nowWaitingUrl, readingSessionsUrl, myPlacesUrl]
		
		let ac = UIActivityViewController(activityItems: urls, applicationActivities: nil)
		let scenes = UIApplication.shared.connectedScenes
		let windowScene = scenes.first as? UIWindowScene
		let window = windowScene?.windows.first
		window?.rootViewController!.present(ac, animated: true, completion: nil)
	}
}
