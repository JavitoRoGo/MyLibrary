//
//  BookEditingExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension BookEditing {
    struct BookEditingModifier: ViewModifier {
        @EnvironmentObject var nrmodel: NowReadingModel
        @Environment(\.dismiss) var dismiss
        @Binding var book: Books
        @Binding var showingAlert: Bool
        @Binding var showingAddWaitingList: Bool
        @Binding var isOnWaitingList: Bool
        let newBookTitle: String
        let newStatus: ReadingStatus
        let newOwner: String
        let newPlace: String
        let newSynopsis: String
        
        func body(content: Content) -> some View {
            content
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
}
