//
//  NowRModelExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 25/2/22.
//

import Foundation
import SwiftUI

// Extension for NowReading: handling with reading and waiting books lists

extension UserViewModel {
	// Actualizar datos para el widget
	func fetchDataToWidget() async {
		if user.sessions.isEmpty {
			if user.nowReading.isEmpty {
				saveDataForWidget(sessions: [], read: loadReadData(), target: loadTargetData())
			} else {
				saveDataForWidget(book: user.nowReading[0], sessions: [], read: loadReadData(), target: loadTargetData())
			}
		} else {
			if user.nowReading.isEmpty {
				saveDataForWidget(sessions: user.sessions, read: loadReadData(), target: loadTargetData())
			} else {
				saveDataForWidget(book: user.nowReading[0], sessions: user.sessions, read: loadReadData(), target: loadTargetData())
			}
		}
	}
	
	// Datos para el Watch
	func fetchDatatoWatch() async {
		user.nowReading.forEach { book in
			if let encoded = try? JSONEncoder().encode(book) {
				ConnectivityMaganer().session.sendMessageData(encoded, replyHandler: nil) { error in
					print(error.localizedDescription)
				}
			}
		}
		
		user.nowWaiting.forEach { book in
			if let encoded = try? JSONEncoder().encode(book) {
				ConnectivityMaganer().session.sendMessageData(encoded, replyHandler: nil) { error in
					print(error.localizedDescription)
				}
			}
		}
	}
    
    var allBookComments: [String: String] {
        var dict: [String: String] = [:]
		for book in user.nowReading where book.comment != nil {
            dict[book.bookTitle] = book.comment
        }
		for book in user.nowWaiting where book.comment != nil {
            dict[book.bookTitle] = book.comment
        }
        return dict
    }
    
    func removeFromReading(_ book: NowReading) {
		if let index = user.nowReading.firstIndex(of: book) {
			user.nowReading.remove(at: index)
        }
    }
        
    func removeFromWaiting(_ book: NowReading) {
		if let index = user.nowWaiting.firstIndex(of: book) {
			user.nowWaiting.remove(at: index)
        }
		if book.formatt == .paper {
			if let index = user.books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				user.books[index].status = .notRead
			}
		} else {
			if let index = user.ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				user.ebooks[index].status = .notRead
			}
		}
    }
    
    func moveToReading(_ book: NowReading) {
        if let index = user.nowWaiting.firstIndex(of: book) {
            user.nowWaiting[index].isOnReading = true
            user.nowReading.append(user.nowWaiting[index])
            user.nowWaiting.remove(at: index)
        }
		if book.formatt == .paper {
			if let index = user.books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				user.books[index].status = .reading
			}
		} else {
			if let index = user.ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				user.ebooks[index].status = .reading
			}
		}
    }
    
    func moveToWaiting(_ book: NowReading) {
        if let index = user.nowReading.firstIndex(of: book) {
            user.nowReading[index].isOnReading = false
            user.nowWaiting.append(user.nowReading[index])
            user.nowReading.remove(at: index)
        }
		if book.formatt == .paper {
			if let index = user.books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				user.books[index].status = .waiting
			}
		} else {
			if let index = user.ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				user.ebooks[index].status = .waiting
			}
		}
    }
    
    func compareExistingBook(formatt: Formatt, text: String) -> (num: Int, datas: [String]) {
        var dataTotalArray = [String]()
        if formatt == .kindle {
            let foundEBookArray = user.ebooks.filter { $0.bookTitle.lowercased().contains(text.lowercased()) }
            foundEBookArray.forEach { ebook in
                dataTotalArray.append(ebook.bookTitle)
            }
        } else {
            let foundBookArray = user.books.filter { $0.bookTitle.lowercased().contains(text.lowercased()) }
            foundBookArray.forEach { book in
                dataTotalArray.append(book.bookTitle)
            }
        }
        return (dataTotalArray.uniqued().count, dataTotalArray.uniqued())
    }
    
    func createNewRD(from book: NowReading, rating: Int) -> ReadingData {
        let rdatas = user.readingDatas
        let newID = rdatas.count + 1
        var newYearID: Int {
            let actualYear = Year.allCases.last
            let lastYearBook = rdatas.last?.finishedInYear
            if lastYearBook == actualYear {
                return Int(rdatas.last!.yearId + 1)
            } else {
                return 1
            }
        }
        let initDate = book.sessions.last!.date
        let endDate = book.sessions.first!.date
        let newFinishedInYear: Year = .allCases.last!
        let newSessions = book.sessions.count
        let newDuration = book.readingTime
        let newPages = book.pages
        var newOver50: Int {
            var over50 = 0
            for session in book.sessions where session.pages >= 50 {
                over50 += 1
            }
            return over50
        }
        let newMinPerPag = book.minPerPag
        let newMinPerDay = book.minPerDay
        let newPagPerDay = Double(book.pagesPerDay)
        var newPercentOver50: Double {
            Double(newOver50) / Double(newSessions) * 100
        }
        let newFormatt = book.formatt
        let newSynopsis = book.synopsis
        let newCover = imageCoverName(from: book.bookTitle)
        let sessions = book.sessions
        
        let comment = book.comment
        let location = book.location
        
        let newRD = ReadingData(
            id: newID, yearId: newYearID, bookTitle: book.bookTitle, startDate: initDate, finishDate: endDate,
            finishedInYear: newFinishedInYear, sessions: newSessions, duration: newDuration, pages: newPages,
            over50: newOver50, minPerPag: newMinPerPag, minPerDay: newMinPerDay, pagPerDay: newPagPerDay,
            percentOver50: newPercentOver50, formatt: newFormatt, rating: rating, synopsis: newSynopsis, cover: newCover,
            comment: comment, location: location, readingSessions: sessions
        )
        return newRD
    }
}
