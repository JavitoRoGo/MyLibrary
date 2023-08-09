//
//  AddEBook.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct AddEBook: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var emodel: EbooksModel
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
        emodel.ebooks.count + 1
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
                Section {
                    VStack(alignment: .leading) {
                        Text("Autor:")
                            .font(.subheadline)
                        TextField("Introduce el autor", text: $newAuthor)
                            .font(.headline)
                            .onSubmit { searchForExistingData(newAuthor) }
                    }
                    VStack(alignment: .leading) {
                        Text("Título:")
                            .font(.subheadline)
                        TextField("Introduce el título", text: $newBookTitle)
                            .font(.headline)
                            .textInputAutocapitalization(.never)
                    }
                    VStack(alignment: .leading) {
                        Text("Título original:")
                            .font(.subheadline)
                        TextField("Introduce el título original", text: $newOriginalTitle)
                            .font(.headline)
                            .textInputAutocapitalization(.never)
                    }
                }
                
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Año:")
                                .font(.subheadline)
                            TextField("", value: $newYear, format: .number)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Páginas:")
                                .font(.subheadline)
                            TextField("", value: $newPages, format: .number)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Precio:")
                                .font(.subheadline)
                            TextField("", value: $newPrice, format: .number)
                                .font(.headline)
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                }
                
                Section {
                    Picker("Propietario:", selection: $newOwner) {
                        ForEach(model.myOwners, id: \.self) {
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
        .modifier(AddEBookModifier(showingAddWaitingAlert: $showingAddWaitingAlert, showingAddWaiting: $showingAddWaiting, showingSearchAlert: $showingSearchAlert, showingSearchResults: $showingSearchResults, newAuthor: $newAuthor, newBookTitle: newBookTitle, synopsis: synopsis, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray))
        .alert("¿Deseas añadir el nuevo registro?", isPresented: $showingAlert) {
            Button("No", role: .cancel) { }
            Button("Sí") {
                let newEBook = createNewEBook()
                emodel.ebooks.append(newEBook)
                showingAddWaitingAlert = true
            }
        } message: {
            Text(newBookTitle)
        }
    }
}

struct AddEBook_Previews: PreviewProvider {
    static var previews: some View {
        AddEBook()
            .environmentObject(UserViewModel())
            .environmentObject(EbooksModel())
    }
}
