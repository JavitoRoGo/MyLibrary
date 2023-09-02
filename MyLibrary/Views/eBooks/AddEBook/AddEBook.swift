//
//  AddEBook.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct AddEBook: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var showingAlert = false
    @State var showingAddWaitingAlert = false
    @State var showingAddWaiting = false
    
    var isDisabled: Bool {
        guard newAuthor.isEmpty || newBookTitle.isEmpty || newOriginalTitle.isEmpty ||
                newYear == 0 || newPages == 0 || newOwner.isEmpty else { return false }
        return true
    }
    var newID: Int {
		model.user.ebooks.count + 1
    }
    
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
        }
        .modifier(AddEBookModifier(showingAddWaitingAlert: $showingAddWaitingAlert, showingAddWaiting: $showingAddWaiting, showingSearchAlert: $showingSearchAlert, showingSearchResults: $showingSearchResults, showingAlert: $showingAlert, newAuthor: $newAuthor, newBookTitle: newBookTitle, synopsis: synopsis, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray, createNewEBook: createNewEBook))
    }
}

struct AddEBook_Previews: PreviewProvider {
    static var previews: some View {
        AddEBook()
            .environmentObject(UserViewModel())
    }
}
