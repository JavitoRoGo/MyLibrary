//
//  ActualReading.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 26/2/22.
//

import SwiftUI

struct ActualReading: View {
	@Environment(GlobalViewModel.self) var model
    
    @State var showingDeletingAlert = false
    @State var showingAddNewBook = false
	@State var bookToDelete = NowReading.dataTest
    
    var body: some View {
        NavigationView {
            List {
				if model.userLogic.user.nowReading.isEmpty && model.userLogic.user.nowWaiting.isEmpty {
                    Text("Parece que no tienes ninguna lectura entre manos ahora mismo. Pulsa el botón de arriba para añadir tu próxima lectura.")
                } else {
                    Section("Leyendo") {
						if model.userLogic.user.nowReading.isEmpty {
                            Text("Parece que no estás leyendo nada ahora. Elige un libro de la Lista de espera y empieza a leer.")
                                .foregroundStyle(.secondary)
                        } else {
							ForEach(model.userLogic.user.nowReading, id:\.bookTitle) { book in
                                NavigationLink(destination: ActualReadingDetail(book: book)) {
                                    ActualReadingRow(book: book)
                                }
                                .swipeActions(edge: .leading) {
                                    Button("En espera") {
                                        withAnimation {
											model.userLogic.moveToWaiting(book)
                                        }
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                    }
                    
                    Section("Lista de espera") {
						if model.userLogic.user.nowWaiting.isEmpty {
                            Text("Parece que no tienes libros esperando a ser leídos. Añade alguno pulsando el botón.")
                                .foregroundColor(.secondary)
						} else {
							ForEach(model.userLogic.user.nowWaiting, id:\.bookTitle) { book in
								NavigationLink(destination: ActualReadingDetail(book: book)) {
									ActualReadingRow(book: book)
								}
								.swipeActions(edge: .leading) {
									Button("Leyendo") {
										withAnimation {
											model.userLogic.moveToReading(book)
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
            }
			.modifier(ActualReadingModifer(showingDeletingAlert: $showingDeletingAlert, showingAddNewBook: $showingAddNewBook, book: bookToDelete, deleteBookAndSessions: deleteBookAndSessions(_:)))
        }
    }
}

struct ActualReading_Previews: PreviewProvider {
    static var previews: some View {
        ActualReading()
			.environment(GlobalViewModel.preview)
    }
}
