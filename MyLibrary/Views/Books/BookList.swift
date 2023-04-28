//
//  BookList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct BookList: View {
    @EnvironmentObject var model: BooksModel
    @State private var searchText = ""
    
    let place: String
    var filterByStatus: FilterByStatus = .all
    var filterByOwner: String = "all"
    
    var filteredBooks: [Books] {
        if place != "all" {
            if filterByStatus == .all && filterByOwner == "all" {
                return model.booksAtPlace(place)
            } else if filterByStatus == .all {
                return model.booksAtPlace(place).filter { $0.owner == filterByOwner }
            } else if filterByOwner == "all" {
                return model.booksAtPlace(place).filter { $0.status.rawValue == filterByStatus.rawValue }
            } else {
                return model.booksAtPlace(place).filter { $0.status.rawValue == filterByStatus.rawValue && $0.owner == filterByOwner }
            }
        } else {
            if filterByStatus == .all && filterByOwner == "all" {
                return model.activeBooks.reversed()
            } else if filterByStatus == .all {
                return model.activeBooks.filter { $0.owner == filterByOwner }.reversed()
            } else if filterByOwner == "all" {
                return model.activeBooks.filter { $0.status.rawValue == filterByStatus.rawValue }.reversed()
            } else {
                return model.activeBooks.filter { $0.status.rawValue == filterByStatus.rawValue && $0.owner == filterByOwner }.reversed()
            }
        }
    }
    var searchedBooks: [Books] {
        if searchText.isEmpty {
            return filteredBooks
        } else {
            return filteredBooks.filter { $0.bookTitle.lowercased().contains(searchText.lowercased()) || $0.author.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        List(searchedBooks) { book in
            NavigationLink(destination: BookDetail(book: book)) {
                BookRow(book: book)
            }
        }
        .navigationTitle("\(place == "all" ? "Todos" : place) (\(filteredBooks.count) entradas)")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Búsqueda por título o autor")
        .disableAutocorrection(true)
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookList(place: "A1")
                .environmentObject(BooksModel())
        }
    }
}
