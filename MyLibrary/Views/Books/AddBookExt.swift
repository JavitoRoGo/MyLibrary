//
//  AddBookExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension AddBook {
    func searchForExistingData(tag: Int, _ text: String) {
        searchResults = bmodel.compareExistingData(tag: tag, text: text).num
        searchArray = bmodel.compareExistingData(tag: tag, text: text).datas
        
        switch searchResults {
        case 6...:
            searchResultsTitle = "Se han encontrado \(searchResults) coincidencias."
            searchResultsMessage = "Realiza una nueva búsqueda para acotar los resultados."
        case 2...5:
            searchResultsTitle = "\(searchResults) coincidencias."
            searchResultsMessage = "Elige un resultado:"
            myTag = tag
            showingSearchResults = true
            return
        case 1:
            if tag == 0 {
                newAuthor = searchArray.first!
            } else if tag == 1 {
                newPublisher = searchArray.first!
            } else {
                newCity = searchArray.first!
            }
            return
        case 0:
            searchResultsTitle = "No se han encontrado coincidencias."
            searchResultsMessage = "Pulsa para continuar."
        default: ()
        }
        
        showingSearchAlert = true
    }
    
    func createNewBook() -> Books {
        return Books(id: newID, author: newAuthor, bookTitle: newBookTitle, originalTitle: newOriginalTitle, publisher: newPublisher, city: newCity, edition: newEdition, editionYear: newYear, writingYear: newWritingYear, coverType: newCoverType, isbn1: newISBN1, isbn2: newISBN2, isbn3: newISBN3, isbn4: newISBN4, isbn5: newISBN5, pages: newPages, height: newHeight, width: newWidth, thickness: newThickness, weight: newWeight, price: newPrice, place: newPlace, owner: newOwner, status: newStatus, isActive: true, synopsis: (newSynopsis.isEmpty ? nil : newSynopsis))
    }
    
    struct AddBookModifier: ViewModifier {
        @EnvironmentObject var bmodel: BooksModel
        @Environment(\.dismiss) var dismiss
        
        @Binding var showingAlert: Bool
        @Binding var showingAddWaitingAlert: Bool
        @Binding var showingAddWaiting: Bool
        @Binding var showingSearchAlert: Bool
        @Binding var showingSearchResults: Bool
        
        @Binding var newAuthor: String
        @Binding var newPublisher: String
        @Binding var newCity: String
        
        let newBook: Books?
        let newBookTitle: String
        let newSynopsis: String
        let searchResultsTitle: String
        let searchResultsMessage: String
        let searchArray: [String]
        let myTag: Int
        
        func body(content: Content) -> some View {
            content
                .alert("¿Deseas añadir el libro a la lista de espera de lectura?", isPresented: $showingAddWaitingAlert) {
                    Button("No", role: .cancel) {
                        dismiss()
                    }
                    Button("Sí") {
                        if let newBook, let index = bmodel.books.firstIndex(of: newBook) {
                            bmodel.books[index].status = .waiting
                        }
                        showingAddWaiting = true
                    }
                }
                .sheet(isPresented: $showingAddWaiting) {
                    NavigationView {
                        AddReading(bookTitle: newBookTitle, synopsis: newSynopsis, formatt: .paper)
                    }
                }
                .alert(searchResultsTitle, isPresented: $showingSearchAlert) {
                    Button("Aceptar") { }
                } message: {
                    Text(searchResultsMessage)
                }
                .confirmationDialog(searchResultsTitle, isPresented: $showingSearchResults, titleVisibility: .visible) {
                    Button("Cancelar", role: .cancel) { }
                    ForEach(searchArray, id: \.self) { data in
                        Button(data) {
                            if myTag == 0 {
                                newAuthor = data
                            } else if myTag == 1 {
                                newPublisher = data
                            } else {
                                newCity = data
                            }
                        }
                    }
                } message: {
                    Text(searchResultsMessage)
                }
        }
    }
}
