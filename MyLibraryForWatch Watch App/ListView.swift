//
//  ListView.swift
//  MyLibraryForWatch Watch App
//
//  Created by Javier Rodríguez Gómez on 2/2/23.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var wcmodel = ConnectivityMaganer()
    
    var readingList: [NowReading] {
        wcmodel.booksOnReading
    }
    var waitingList: [NowReading] {
        wcmodel.booksOnWaiting
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Leyendo") {
                    if readingList.isEmpty {
                        Text("Añade un libro desde la app del iPhone.")
                    } else {
                        ForEach(readingList, id: \.bookTitle) { book in
                            NavigationLink(destination: DetailView(book: book)) {
                                Text(book.bookTitle)
                            }
                        }
                    }
                }
                Section("En espera") {
                    if waitingList.isEmpty {
                        Text("Añade libros en espera desde la app del iPhone.")
                    } else {
                        ForEach(waitingList, id: \.bookTitle) { book in
                            Text(book.bookTitle)
                        }
                    }
                }
            }
            .navigationTitle("Lecturas")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
