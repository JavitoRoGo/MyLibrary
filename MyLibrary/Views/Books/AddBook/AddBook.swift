//
//  AddBook.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/1/22.
//

import SwiftUI

struct AddBook: View {
    @EnvironmentObject var model: UserViewModel
    
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
	
	@State var showingCoverSelection = false
	@State var showingImagePicker = false
	@State var showingCameraPicker = false
	@State var showingDownloadPage = false
	@State var inputImage: UIImage?
        
    var body: some View {
        NavigationStack {
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
			.modifier(AddBookModifier(showingAlert: $showingAlert, showingAddWaitingAlert: $showingAddWaitingAlert, showingAddWaiting: $showingAddWaiting, showingSearchAlert: $showingSearchAlert, showingSearchResults: $showingSearchResults, newAuthor: $newAuthor, newPublisher: $newPublisher, newCity: $newCity, newBook: $newBook, showingCoverSelection: $showingCoverSelection, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingDownloadPage: $showingDownloadPage, inputImage: $inputImage, newBookTitle: newBookTitle, newSynopsis: newSynopsis, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray, myTag: myTag, newID: newID, isDisabled: isDisabled, createNewBook: createNewBook))
        }
    }
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
            .environmentObject(UserViewModel())
    }
}
