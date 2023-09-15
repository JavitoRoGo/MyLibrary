//
//  EBookDetailExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension EBookDetail {
    struct EBookDetailModifier: ViewModifier {
        @EnvironmentObject var model: UserViewModel
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
				.navigationTitle("Detalle (\(ebook.id) de \(model.user.ebooks.count))")
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
					if let rdata = model.user.readingDatas.first(where: { $0.bookTitle == ebook.bookTitle }) {
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
					if let rsdata = model.user.nowReading.first(where: { $0.bookTitle == ebook.bookTitle }) {
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
						if let index = model.user.ebooks.firstIndex(of: ebook) {
							model.user.ebooks.remove(at: index)
							if let file = ebook.cover {
								removeJpgFromFileManager(file)
							}
                            dismiss()
                        }
                    }
                } message: {
                    Text("Esta acción no podrá deshacerse.")
                }
        }
    }
}
