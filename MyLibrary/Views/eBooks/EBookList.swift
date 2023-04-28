//
//  EBookList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookList: View {
    @EnvironmentObject var model: EbooksModel
    @State private var searchText = ""
    let filter: FilterByStatus
    var filteredOwner: String? = nil
    
    var filteredEBooks: [EBooks] {
        if filter == .all {
            return model.ebooks.reversed()
        } else {
            return model.ebooks.filter { $0.status.rawValue == filter.rawValue }.reversed()
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
            return "\(filteredOwner) - \(model.numByOwner(filteredOwner))"
        }
        return "\(filter.rawValue) - \(filteredEBooks.count)"
    }
    
    var body: some View {
        List(ebooksToShow) { ebook in
            let index = model.ebooks.firstIndex(of: ebook)!
            NavigationLink(destination: EBookDetail(ebook: $model.ebooks[index], newStatus: ebook.status)) {
                EBookRow(ebook: ebook)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Búsqueda por título o autor")
        .disableAutocorrection(true)
    }
}

struct EBookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EBookList(filter: .all, filteredOwner: nil)
                .environmentObject(EbooksModel())
        }
    }
}
