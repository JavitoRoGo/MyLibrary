//
//  AddEBook.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct AddEBook: View {
    @EnvironmentObject var model: UserViewModel
    
    @State var showingAlert = false
    @State var showingAddWaitingAlert = false
    @State var showingAddWaiting = false
	@State var showingCoverSelection = false
	@State var showingImagePicker = false
	@State var showingCameraPicker = false
	@State var showingDownloadPage = false
	@State var inputImage: UIImage?
    
    @State var newAuthor = ""
    @State var newBookTitle = ""
    @State var newOriginalTitle = ""
    @State var newYear = 0
    @State var newPages = 0
    @State var newPrice = 0.0
    @State var newOwner = ""
    @State var newStatus: ReadingStatus = .notRead
    @State var synopsis = ""
    
    @State var showingSearchResults = false
    @State var showingSearchAlert = false
    @State var searchResultsTitle = ""
    @State var searchResultsMessage = ""
    @State var searchResults = 0
    @State var searchArray = [String]()
    
    var body: some View {
        NavigationStack {
            Form {
                authorSection
                
                yearSection
                
                Section {
                    Picker("Propietario:", selection: $newOwner) {
						ForEach(model.user.myOwners, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Estado:", selection: $newStatus) {
                        ForEach(ReadingStatus.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                .pickerStyle(.menu)
                
                Section("Resumen") {
                    TextEditor(text: $synopsis)
                        .frame(height: 200)
                }
            }
			.modifier(AddEBookModifier(showingAddWaitingAlert: $showingAddWaitingAlert, showingAddWaiting: $showingAddWaiting, showingSearchAlert: $showingSearchAlert, showingSearchResults: $showingSearchResults, showingAlert: $showingAlert, showingCoverSelection: $showingCoverSelection, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingDownloadPage: $showingDownloadPage, inputImage: $inputImage, newAuthor: $newAuthor, newID: newID, newBookTitle: newBookTitle, synopsis: synopsis, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray, createNewEBook: createNewEBook))
        }
    }
}

struct AddEBook_Previews: PreviewProvider {
    static var previews: some View {
        AddEBook()
            .environmentObject(UserViewModel())
    }
}
