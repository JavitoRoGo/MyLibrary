//
//  BookList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct BookList: View {
    @Environment(GlobalViewModel.self) var model
    @State private var searchText = ""
	@State var customPreferredGridView: Bool
    
    let place: String
    var filterByStatus: FilterByStatus = .all
    var filterByOwner: String = "all"
    
    var filteredBooks: [Books] {
        if place != "all" {
			return model.userLogic.booksAtPlace(place)
        } else {
			if filterByOwner != "all" {
				return model.userLogic.activeBooks.filter { $0.owner == filterByOwner }.reversed()
			} else if filterByStatus != .all {
				return model.userLogic.activeBooks.filter { $0.status.rawValue == filterByStatus.rawValue }.reversed()
			} else {
				return model.userLogic.activeBooks.reversed()
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
	
	var navigationTitle: String {
		if filterByStatus != .all {
			return "\(filterByStatus.rawValue) - \(filteredBooks.count)"
		}
		if filterByOwner != "all" {
			return "\(filterByOwner) - \(filteredBooks.count)"
		}
		return "\(place == "all" ? "Todos" : place) - \(filteredBooks.count)"
	}
    
    var body: some View {
		NavigationStack {
			if customPreferredGridView {
				BooksGrid(books: filteredBooks)
			} else {
				List(searchedBooks) { book in
					NavigationLink(destination: BookDetail(book: book)) {
						BookRow(book: book)
					}
				}
				.searchable(text: $searchText, prompt: "Búsqueda por título o autor")
				.disableAutocorrection(true)
			}
		}
		.navigationTitle(navigationTitle)
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					withAnimation {
						customPreferredGridView.toggle()
					}
				} label: {
					Image(systemName: customPreferredGridView ? "list.star" : "square.grid.3x3")
				}
				
			}
		}
    }
}

struct BookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
			BookList(customPreferredGridView: false, place: "A1")
				.environment(GlobalViewModel.preview)
        }
    }
}
