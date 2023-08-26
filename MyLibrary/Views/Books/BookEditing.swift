//
//  BookEditing.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/21.
//

import SwiftUI

struct BookEditing: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var book: Books
    @State var newBookTitle: String
    @State var newStatus: ReadingStatus
    @State var newOwner: String
    @State var newPlace: String
    @State var newSynopsis: String
    
    @State var showingAlert = false
    @State var showingAddWaitingList = false
    @State var isOnWaitingList = false
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancelar") {
                    dismiss()
                }
                Spacer()
                Text("Editando...")
                Spacer()
                Button("Modificar") {
                    showingAlert = true
                }
            }
            .padding([.top, .leading, .trailing])
            
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Título:")
                            .font(.subheadline)
                        TextField(book.bookTitle, text: $newBookTitle)
                            .font(.headline)
                            .disableAutocorrection(true)
                    }
                }
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Estado:")
                                .font(.subheadline)
                            Picker("Estado", selection: $newStatus) {
                                ForEach(ReadingStatus.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
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
                            .pickerStyle(.menu)
                        }
                        Spacer()
                        VStack(alignment: .center) {
                            Text("Propietario:")
                                .font(.subheadline)
                            Picker("Propietario", selection: $newOwner) {
                                ForEach(model.myOwners, id: \.self) {
                                    Text($0)
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(.menu)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $newSynopsis)
                        .frame(height: 150)
                }
                Section {
                    if newStatus == .notRead || newStatus == .reading || newStatus == .waiting {
                        HStack {
                            Text("¿Está en la lista de lectura?")
                            Spacer()
                            Image(systemName: isOnWaitingList ? "star.fill" : "star")
                                .foregroundColor(isOnWaitingList ? .yellow : .gray.opacity(0.8))
                        }
                        Toggle("Añadir a la lista de lectura", isOn: $showingAddWaitingList)
                            .foregroundColor(isOnWaitingList ? .secondary : .primary)
                            .disabled(isOnWaitingList)
                    }
                }
            }
        }
        .modifier(BookEditingModifier(book: $book, showingAlert: $showingAlert, showingAddWaitingList: $showingAddWaitingList, isOnWaitingList: $isOnWaitingList, newBookTitle: newBookTitle, newStatus: newStatus, newOwner: newOwner, newPlace: newPlace, newSynopsis: newSynopsis))
    }
}

struct BookEditing_Previews: PreviewProvider {
    static var previews: some View {
        BookEditing(book: .constant(Books.dataTest), newBookTitle: "Título de prueba", newStatus: .notRead, newOwner: "Yo", newPlace: "A1", newSynopsis: "Resumen de prueba.")
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
    }
}
