//
//  EBookListExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import Foundation

extension EBookList {
    var filteredEBooks: [EBooks] {
        if filter == .all {
			return model.userLogic.user.ebooks.reversed()
        } else {
			return model.userLogic.user.ebooks.filter { $0.status.rawValue == filter.rawValue }.reversed()
        }
    }
    var searchedEBooks: [EBooks] {
        if searchText.isEmpty {
            return filteredEBooks
        } else {
            return filteredEBooks.filter { $0.bookTitle.lowercased().contains(searchText.lowercased()) || $0.author.lowercased().contains(searchText.lowercased()) }
        }
    }
    var ebooksToShow: [EBooks] {
        if let filteredOwner {
            return searchedEBooks.filter { $0.owner == filteredOwner }
        }
        return searchedEBooks
    }
    var navigationTitle: String {
        if let filteredOwner {
			return "\(filteredOwner) - \(model.userLogic.numberOfEbooksByOwner(filteredOwner))"
        }
        return "\(filter.rawValue) - \(filteredEBooks.count)"
    }
}
