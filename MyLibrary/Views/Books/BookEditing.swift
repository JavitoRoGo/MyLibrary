//
//  BookEditing.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/21.
//

import SwiftUI

struct BookEditing: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var nrmodel: NowReadingModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var book: Books
    @State var newBookTitle: String
    @State var newStatus: ReadingStatus
    @State var newOwner: String
    @State var newPlace: String
    @State var newSynopsis: String
    
    @State private var showingAlert = false
    @State private var showingAddWaitingList = false
    @State private var isOnWaitingList = false
    
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
        .alert("Se va a modificar este registro.", isPresented: $showingAlert) {
            Button("No", role: .cancel) { }
            Button("Sí") {
                book.bookTitle = newBookTitle
                book.status = newStatus
                book.owner = newOwner
                book.place = newPlace
                if newPlace == soldText || newPlace == donatedText {
                    book.isActive = false
                }
                book.synopsis = newSynopsis
                dismiss()
            }
        } message: {
            Text("¿Deseas guardar los nuevos datos?")
        }
        .sheet(isPresented: $showingAddWaitingList) {
            NavigationView {
                AddReading(bookTitle: newBookTitle, synopsis: newSynopsis, formatt: .paper)
            }
        }
        .onAppear {
            isOnWaitingList = nrmodel.readingList.contains(where: { $0.bookTitle == book.bookTitle }) ||
            nrmodel.waitingList.contains(where: { $0.bookTitle == book.bookTitle })
        }
    }
}

struct BookEditing_Previews: PreviewProvider {
    static var previews: some View {
        BookEditing(book: .constant(Books.dataTest), newBookTitle: "Título de prueba", newStatus: .notRead, newOwner: "Yo", newPlace: "A1", newSynopsis: "Resumen de prueba.")
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
            .environmentObject(NowReadingModel())
    }
}
