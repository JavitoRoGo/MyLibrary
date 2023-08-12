//
//  EBookDetailExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension EBookDetail {
    struct EBookDetailModifier: ViewModifier {
        @EnvironmentObject var emodel: EbooksModel
        @EnvironmentObject var rdmodel: RDModel
        @EnvironmentObject var nrmodel: NowReadingModel
        @Environment(\.dismiss) var dismiss
        
        @Binding var showingDeleteAlert: Bool
        @Binding var showingEditPage: Bool
        @Binding var showingInfoAlert: Bool
        @Binding var showingRDDetail: Bool
        @Binding var showingRSDetail: Bool
        
        let ebook: EBooks
        let titleInfoAlert: String
        let messageInfoAlert: String
        
        func body(content: Content) -> some View {
            content
                .navigationTitle("Detalle (\(ebook.id) de \(emodel.ebooks.count))")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    HStack {
                        Button {
                            showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                        Button {
                            showingEditPage = true
                        } label: {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                        }
                        .disabled(showingEditPage)
                    }
                }
                .alert(titleInfoAlert, isPresented: $showingInfoAlert) {
                    if ebook.status == .registered {
                        Button("Cancelar", role: .cancel) { }
                        Button("Ver") {
                            showingRDDetail = true
                        }
                    } else if ebook.status == .reading {
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
                    if let rdata = rdmodel.readingDatas.first(where: { $0.bookTitle == ebook.bookTitle }) {
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
                }
                .sheet(isPresented: $showingRSDetail) {
                    if let rsdata = nrmodel.readingList.first(where: { $0.bookTitle == ebook.bookTitle }) {
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
                .alert("¿Deseas eliminar este registro?", isPresented: $showingDeleteAlert) {
                    Button("Cancelar", role: .cancel) { }
                    Button("Eliminar", role: .destructive) {
                        if let index = emodel.ebooks.firstIndex(of: ebook) {
                            emodel.ebooks.remove(at: index)
                            dismiss()
                        }
                    }
                } message: {
                    Text("Esta acción no podrá deshacerse.")
                }
        }
    }
}
