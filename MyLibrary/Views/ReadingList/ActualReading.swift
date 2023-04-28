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
    
    @State private var showingDeletingAlert = false
    @State private var showingAddNewBook = false
    
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
        
    func deleteBook(_ book: NowReading) {
        if book.sessions.isEmpty == false {
            showingDeletingAlert = true
        } else {
            model.removeFromWaiting(book)
            changeToNotRead(book)
        }
    }
    
    func changeToReading(_ book: NowReading) {
        if book.formatt == .paper {
            if let index = BooksModel().books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
                bmodel.books[index].status = .reading
            }
        } else {
            if let index = EbooksModel().ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
                emodel.ebooks[index].status = .reading
            }
        }
    }
    
    func changeToWaiting(_ book: NowReading) {
        if book.formatt == .paper {
            if let index = BooksModel().books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
                BooksModel().books[index].status = .waiting
            }
        } else {
            if let index = EbooksModel().ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
                EbooksModel().ebooks[index].status = .waiting
            }
        }
    }
    
    func changeToNotRead(_ book: NowReading) {
        if book.formatt == .paper {
            if let index = bmodel.books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
                bmodel.books[index].status = .notRead
            }
        } else {
            if let index = emodel.ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
                emodel.ebooks[index].status = .notRead
            }
        }
    }
    
    func shareButton() {
        let userUrl = getURLToShare(from: userJson)
        let booksUrl = getURLToShare(from: booksJson)
        let ebooksUrl = getURLToShare(from: ebooksJson)
        let readingDataUrl = getURLToShare(from: readingDataJson)
        let nowReadingUrl = getURLToShare(from: nowReadingJson)
        let nowWaitingUrl = getURLToShare(from: nowWaitingJson)
        let readingSessionsUrl = getURLToShare(from: readingSessionsJson)
        let myPlacesUrl = getURLToShare(from: myPlacesJson)
        let urls = [userUrl, booksUrl, ebooksUrl, readingDataUrl, nowReadingUrl, nowWaitingUrl, readingSessionsUrl, myPlacesUrl]
        
        let ac = UIActivityViewController(activityItems: urls, applicationActivities: nil)
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController!.present(ac, animated: true, completion: nil)
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
