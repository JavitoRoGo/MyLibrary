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
    
    @State private var showingAlert = false
    @State private var showingAddWaitingAlert = false
    @State private var showingAddWaiting = false
    
    var isDisabled: Bool {
        guard newAuthor.isEmpty || newBookTitle.isEmpty || newOriginalTitle.isEmpty ||
                newYear == 0 || newPages == 0 || newOwner.isEmpty else { return false }
        return true
    }
    var newID: Int {
        emodel.ebooks.count + 1
    }
    
    @State private var newAuthor = ""
    @State private var newBookTitle = ""
    @State private var newOriginalTitle = ""
    @State private var newYear = 0
    @State private var newPages = 0
    @State private var newPrice = 0.0
    @State private var newOwner = ""
    @State private var newStatus: ReadingStatus = .notRead
    @State private var synopsis = ""
    
    @State private var showingSearchResults = false
    @State private var showingSearchAlert = false
    @State private var searchResultsTitle = ""
    @State private var searchResultsMessage = ""
    @State private var searchResults = 0
    @State private var searchArray = [String]()
    
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
        .disableAutocorrection(true)
        .alert("¿Deseas añadir el nuevo registro?", isPresented: $showingAlert) {
            Button("No", role: .cancel) { }
            Button("Sí") {
                let newEBook = EBooks(id: newID, author: newAuthor, bookTitle: newBookTitle, originalTitle: newOriginalTitle, year: newYear, pages: newPages, price: newPrice, owner: newOwner, status: newStatus, synopsis: synopsis.isEmpty ? nil : synopsis)
                emodel.ebooks.append(newEBook)
                showingAddWaitingAlert = true
            }
        } message: {
            Text(newBookTitle)
        }
        .alert("¿Deseas añadir el ebook a la lista de espera de lectura?", isPresented: $showingAddWaitingAlert) {
            Button("No", role: .cancel) {
                dismiss()
            }
            Button("Sí") {
                showingAddWaiting = true
            }
        }
        .sheet(isPresented: $showingAddWaiting) {
            NavigationView {
                AddReading(bookTitle: newBookTitle, synopsis: synopsis, formatt: .kindle)
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
                   newAuthor = data
                }
            }
        } message: {
            Text(searchResultsMessage)
        }
    }
    
    func searchForExistingData(_ text: String) {
        searchResults = emodel.compareExistingAuthors(text: text).num
        searchArray = emodel.compareExistingAuthors(text: text).authors
        
        switch searchResults {
        case 6...:
            searchResultsTitle = "Se han encontrado \(searchResults) coincidencias."
            searchResultsMessage = "Realiza una nueva búsqueda para acotar los resultados."
        case 2...5:
            searchResultsTitle = "\(searchResults) coincidencias."
            searchResultsMessage = "Elige un resultado:"
            showingSearchResults = true
            return
        case 1:
            newAuthor = searchArray.first!
            return
        case 0:
            searchResultsTitle = "No se han encontrado coincidencias."
            searchResultsMessage = "Pulsa para continuar."
        default: ()
        }
        
        showingSearchAlert = true
    }
}

struct AddEBook_Previews: PreviewProvider {
    static var previews: some View {
        AddEBook()
            .environmentObject(UserViewModel())
            .environmentObject(EbooksModel())
    }
}
