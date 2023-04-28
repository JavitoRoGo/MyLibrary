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
    
    @State private var showingAlert = false
    @State private var showingAddWaitingAlert = false
    @State private var showingAddWaiting = false
    
    var isDisabled: Bool {
        guard newAuthor.isEmpty || newBookTitle.isEmpty || newOriginalTitle.isEmpty ||
                newPublisher.isEmpty || newCity.isEmpty || newEdition == 0 ||
                newYear == 0 || newWritingYear == 0 || newPages == 0 || newPlace.isEmpty ||
                newOwner.isEmpty || newWeight == 0 || newHeight == 0 || newWidth == 0 ||
                newThickness == 0 else { return false }
        return true
    }
    
    @State private var newBook: Books?
    var newID: Int {
        bmodel.books.count + 1
    }
    @State private var newAuthor = ""
    @State private var newBookTitle = ""
    @State private var newOriginalTitle = ""
    @State private var newPublisher = ""
    @State private var newCity = ""
    @State private var newEdition = 0
    @State private var newYear = 0
    @State private var newWritingYear = 0
    @State private var newCoverType: Cover = .pocket
    @State private var newISBN1 = 0
    @State private var newISBN2 = 0
    @State private var newISBN3 = 0
    @State private var newISBN4 = 0
    @State private var newISBN5 = 0
    @State private var newPages = 0
    @State private var newPrice = 0.0
    @State private var newWeight = 0
    @State private var newHeight = 0.0
    @State private var newWidth = 0.0
    @State private var newThickness = 0.0
    @State private var newOwner = ""
    @State private var newPlace = ""
    @State private var newStatus: ReadingStatus = .notRead
    @State private var newSynopsis = ""
    
    @State private var showingSearchResults = false
    @State private var showingSearchAlert = false
    @State private var searchResultsTitle = ""
    @State private var searchResultsMessage = ""
    @State private var searchResults = 0
    @State private var searchArray = [String]()
    @State private var myTag = 0
        
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
                            .tag(0)
                            .onSubmit { searchForExistingData(tag: 0, newAuthor) }
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
                    VStack(alignment: .leading) {
                        Text("Editorial:")
                            .font(.subheadline)
                        TextField("Introduce la editorial", text: $newPublisher)
                            .font(.headline)
                            .tag(1)
                            .onSubmit { searchForExistingData(tag: 1, newPublisher) }
                    }
                    VStack(alignment: .leading) {
                        Text("Ciudad:")
                            .font(.subheadline)
                        TextField("Introduce la ciudad", text: $newCity)
                            .font(.headline)
                            .tag(2)
                            .onSubmit { searchForExistingData(tag: 2, newCity) }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Edición:")
                                .font(.subheadline)
                            TextField("", value: $newEdition, format: .number)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Año:")
                                .font(.subheadline)
                            TextField("", value: $newYear, format: .number)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Año escritura:")
                                .font(.subheadline)
                            TextField("", value: $newWritingYear, format: .number)
                                .font(.headline)
                        }
                    }
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Encuadernación:")
                                .font(.subheadline)
                            Picker("Encuadernación", selection: $newCoverType) {
                                ForEach(Cover.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .pickerStyle(.menu)
                            .labelsHidden()
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("ISBN:")
                                .font(.subheadline)
                            HStack {
                                TextField("", value: $newISBN1, format: .number)
                                TextField("", value: $newISBN2, format: .number)
                                TextField("", value: $newISBN3, format: .number)
                                TextField("", value: $newISBN4, format: .number)
                                TextField("", value: $newISBN5, format: .number)
                            }
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                        }
                    }
                }
                
                Section {
                    HStack {
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
                            TextField("", value: $newPrice, format: .currency(code: "EUR"))
                                .font(.headline)
                                .keyboardType(.decimalPad)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Peso (g):")
                                .font(.subheadline)
                            TextField("", value: $newWeight, format: .number)
                                .font(.headline)
                        }
                    }
                    .keyboardType(.numberPad)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Alto (cm):")
                                .font(.subheadline)
                            TextField("", value: $newHeight, format: .number)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Ancho (cm):")
                                .font(.subheadline)
                            TextField("", value: $newWidth, format: .number)
                                .font(.headline)
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Grosor (cm):")
                                .font(.subheadline)
                            TextField("", value: $newThickness, format: .number)
                                .font(.headline)
                        }
                    }
                    .keyboardType(.decimalPad)
                }
                .textFieldStyle(.roundedBorder)
                
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Propietario:")
                                .font(.subheadline)
                            Picker("Propietario", selection: $newOwner) {
                                ForEach(model.myOwners, id: \.self) {
                                    Text($0)
                                }
                            }
                            .labelsHidden()
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Text("Estado:")
                                .font(.subheadline)
                            Picker("Estado", selection: $newStatus) {
                                ForEach(ReadingStatus.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .labelsHidden()
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Text("Ubicación:")
                                .font(.subheadline)
                            Picker("Ubicación", selection: $newPlace) {
                                ForEach(model.myPlaces, id: \.self) {
                                    Text($0)
                                }
                            }
                            .labelsHidden()
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Resumen") {
                    TextEditor(text: $newSynopsis)
                        .frame(height: 150)
                }
            }
        }
        .disableAutocorrection(true)
        .alert("¿Deseas añadir el nuevo registro?", isPresented: $showingAlert) {
            Button("No", role: .cancel) { }
            Button("Sí") {
                newBook = Books(id: newID, author: newAuthor, bookTitle: newBookTitle, originalTitle: newOriginalTitle, publisher: newPublisher, city: newCity, edition: newEdition, editionYear: newYear, writingYear: newWritingYear, coverType: newCoverType, isbn1: newISBN1, isbn2: newISBN2, isbn3: newISBN3, isbn4: newISBN4, isbn5: newISBN5, pages: newPages, height: newHeight, width: newWidth, thickness: newThickness, weight: newWeight, price: newPrice, place: newPlace, owner: newOwner, status: newStatus, isActive: true, synopsis: (newSynopsis.isEmpty ? nil : newSynopsis))
                bmodel.books.append(newBook!)
                
                showingAddWaitingAlert = true
            }
        } message: {
            Text(newBookTitle)
        }
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
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
    }
}
