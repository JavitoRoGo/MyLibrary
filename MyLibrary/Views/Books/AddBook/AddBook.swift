//
//  AddBook.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/1/22.
//

import SwiftUI

struct AddBook: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @Environment(\.dismiss) var dismiss
    
    @State var showingAlert = false
    @State var showingAddWaitingAlert = false
    @State var showingAddWaiting = false
    
    @State var newBook: Books?
    
    @State var newAuthor = ""
    @State var newBookTitle = ""
    @State var newOriginalTitle = ""
    @State var newPublisher = ""
    @State var newCity = ""
    @State var newEdition = 0
    @State var newYear = 0
    @State var newWritingYear = 0
    @State var newCoverType: Cover = .pocket
    @State var newISBN1 = 0
    @State var newISBN2 = 0
    @State var newISBN3 = 0
    @State var newISBN4 = 0
    @State var newISBN5 = 0
    @State var newPages = 0
    @State var newPrice = 0.0
    @State var newWeight = 0
    @State var newHeight = 0.0
    @State var newWidth = 0.0
    @State var newThickness = 0.0
    @State var newOwner = ""
    @State var newPlace = ""
    @State var newStatus: ReadingStatus = .notRead
    @State var newSynopsis = ""
    
    @State var showingSearchResults = false
    @State var showingSearchAlert = false
    @State var searchResultsTitle = ""
    @State var searchResultsMessage = ""
    @State var searchResults = 0
    @State var searchArray = [String]()
    @State var myTag = 0
        
    var body: some View {
        VStack {
            HStack {
                Button("Cancelar") {
                    dismiss()
                }
                Spacer()
                Text("Nuevo registro: \(newID)")
                Spacer()
                Button("Añadir") {
                    showingAlert = true
                }
                .disabled(isDisabled)
            }
            .padding([.top, .leading, .trailing])
            
            Form {
                authorSection
                
                publisherSection
                
                physicsSection
                
                ownerSection
                
                Section("Resumen") {
                    TextEditor(text: $newSynopsis)
                        .frame(height: 150)
                }
            }
        }
        .modifier(AddBookModifier(showingAlert: $showingAlert, showingAddWaitingAlert: $showingAddWaitingAlert, showingAddWaiting: $showingAddWaiting, showingSearchAlert: $showingSearchAlert, showingSearchResults: $showingSearchResults, newAuthor: $newAuthor, newPublisher: $newPublisher, newCity: $newCity, newBook: $newBook, newBookTitle: newBookTitle, newSynopsis: newSynopsis, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray, myTag: myTag, createNewBook: createNewBook))
    }
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
    }
}
