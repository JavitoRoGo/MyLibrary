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
    
    var isDisabled: Bool {
        guard newAuthor.isEmpty || newBookTitle.isEmpty || newOriginalTitle.isEmpty ||
                newPublisher.isEmpty || newCity.isEmpty || newEdition == 0 ||
                newYear == 0 || newWritingYear == 0 || newPages == 0 || newPlace.isEmpty ||
                newOwner.isEmpty || newWeight == 0 || newHeight == 0 || newWidth == 0 ||
                newThickness == 0 else { return false }
        return true
    }
    
    @State var newBook: Books?
    var newID: Int {
        bmodel.books.count + 1
    }
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
                newBook = createNewBook()
                bmodel.books.append(newBook!)
                
                showingAddWaitingAlert = true
            }
        } message: {
            Text(newBookTitle)
        }
        .modifier(AddBookModifier(showingAlert: $showingAlert, showingAddWaitingAlert: $showingAddWaitingAlert, showingAddWaiting: $showingAddWaiting, showingSearchAlert: $showingSearchAlert, showingSearchResults: $showingSearchResults, newAuthor: $newAuthor, newPublisher: $newPublisher, newCity: $newCity, newBook: newBook, newBookTitle: newBookTitle, newSynopsis: newSynopsis, searchResultsTitle: searchResultsTitle, searchResultsMessage: searchResultsMessage, searchArray: searchArray, myTag: myTag))
    }
}

struct AddBook_Previews: PreviewProvider {
    static var previews: some View {
        AddBook()
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
    }
}
