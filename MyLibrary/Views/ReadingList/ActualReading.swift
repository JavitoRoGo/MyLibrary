//
//  ActualReading.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 26/2/22.
//

import SwiftUI

struct ActualReading: View {
    @EnvironmentObject var model: NowReadingModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    
    @State var showingDeletingAlert = false
    @State var showingAddNewBook = false
    
    var body: some View {
        NavigationView {
            List {
                if model.readingList.isEmpty && model.waitingList.isEmpty {
                    Text("Parece que no tienes ninguna lectura entre manos ahora mismo. Pulsa el botón de arriba para añadir tu próxima lectura.")
                } else {
                    Section("Leyendo") {
                        if model.readingList.isEmpty {
                            Text("Parece que no estás leyendo nada ahora. Elige un libro de la Lista de espera y empieza a leer.")
                                .foregroundColor(.secondary)
                        } else {
                            ForEach(model.readingList, id:\.bookTitle) { book in
                                NavigationLink(destination: ActualReadingDetail(book: book)) {
                                    ActualReadingRow(book: book)
                                }
                                .swipeActions(edge: .leading) {
                                    Button("En espera") {
                                        withAnimation {
                                            changeToWaiting(book)
                                            model.moveToWaiting(book)
                                        }
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                    }
                    
                    Section("Lista de espera") {
                        if model.waitingList.isEmpty {
                            Text("Parece que no tienes libros esperando a ser leídos. Añade alguno pulsando el botón.")
                                .foregroundColor(.secondary)
                        }
                        ForEach(model.waitingList, id:\.bookTitle) { book in
                            NavigationLink(destination: ActualReadingDetail(book: book)) {
                                ActualReadingRow(book: book)
                            }
                            .swipeActions(edge: .leading) {
                                Button("Leyendo") {
                                    withAnimation {
                                        changeToReading(book)
                                        model.moveToReading(book)
                                    }
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        deleteBook(book)
                                    }
                                } label: {
                                    Label("Borrar", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Leyendo... y en espera")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        shareButton()
                    } label: {
                        Label("Exportar", systemImage: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNewBook = true
                    } label: {
                        Label("Añadir libro", systemImage: "doc.badge.plus")
                    }
                }
            }
            .alert("¡Atención!\nEstás intentando borrar un libro con datos de lectura.", isPresented: $showingDeletingAlert) {
                Button("Aceptar") { }
            } message: {
                Text("Esta acción no está permitida.")
            }
            .sheet(isPresented: $showingAddNewBook) {
                NavigationView {
                    AddReading(bookTitle: "", synopsis: "", formatt: .paper)
                }
            }
        }
    }
}

struct ActualReading_Previews: PreviewProvider {
    static var previews: some View {
        ActualReading()
            .environmentObject(NowReadingModel())
            .environmentObject(BooksModel())
            .environmentObject(EbooksModel())
    }
}
