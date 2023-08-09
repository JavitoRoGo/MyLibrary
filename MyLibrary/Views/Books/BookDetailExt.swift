//
//  BookDetailExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension BookDetail {
    struct BookDetailModifier: ViewModifier {
        @EnvironmentObject var model: BooksModel
        @EnvironmentObject var rdmodel: RDModel
        @EnvironmentObject var nrmodel: NowReadingModel
        let book: Books
        @Binding var showingDelete: Bool
        @Binding var showingEditPage: Bool
        @Binding var showingInfoAlert: Bool
        @Binding var showingRDDetail: Bool
        @Binding var showingRSDetail: Bool
        let titleInfoAlert: String
        let messageInfoAlert: String
        
        func body(content: Content) -> some View {
            content
                .navigationTitle("Detalle (\(book.id) de \(model.activeBooks.count))")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    if book.isActive {
                        HStack {
                            Button {
                                showingDelete = true
                            } label: {
                                Image(systemName: "trash")
                            }
                            .disabled(book.status == .reading || book.status == .waiting)
                            Button {
                                showingEditPage = true
                            } label: {
                                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingEditPage) {
                    if let index = model.books.firstIndex(of: book) {
                        BookEditing(book: $model.books[index], newBookTitle: book.bookTitle, newStatus: book.status, newOwner: book.owner, newPlace: book.place, newSynopsis: book.synopsis ?? "Sinopsis no disponible.")
                    }
                }
                .alert(titleInfoAlert, isPresented: $showingInfoAlert) {
                    if book.status == .registered {
                        Button("Cancelar", role: .cancel) { }
                        Button("Ver") {
                            showingRDDetail = true
                        }
                    } else if book.status == .reading {
                        Button("Cancelar", role: .cancel) { }
                        Button("Ver") {
                            showingRSDetail = true
                        }
                    } else {
                        Button("Aceptar", role: .cancel) { }
                    }
                } message: {
                    Text(messageInfoAlert)
                }
                .sheet(isPresented: $showingRDDetail) {
                    let rdata = rdmodel.readingDatas.first(where: { $0.bookTitle == book.bookTitle })!
                    NavigationView {
                        RDDetail(rdata: rdata)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancelar") {
                                        showingRDDetail = false
                                    }
                                }
                            }
                    }
                }
                .sheet(isPresented: $showingRSDetail) {
                    if let rsdata = nrmodel.readingList.first(where: { $0.bookTitle == book.bookTitle }) {
                        NavigationView {
                            ActualReadingDetail(book: rsdata)
                                .toolbar {
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancelar") {
                                            showingRSDetail = false
                                        }
                                    }
                                }
                        }
                    }
                }
                .alert("¿Deseas eliminar este registro?", isPresented: $showingDelete) {
                    Button("Cancelar", role: .cancel) { }
                    Button(soldText, role: .destructive) {
                        let index = model.books.firstIndex(of: book)!
                        model.books[index].place = soldText
                        model.books[index].isActive = false
                    }
                    Button(donatedText, role: .destructive) {
                        let index = model.books.firstIndex(of: book)!
                        model.books[index].place = donatedText
                        model.books[index].isActive = false
                    }
                } message: {
                    Text("Indica si el libro ha sido vendido o donado.")
                }
        }
    }
}
