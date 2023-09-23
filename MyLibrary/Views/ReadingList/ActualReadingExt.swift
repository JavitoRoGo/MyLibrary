//
//  ActualReadingExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/8/23.
//

import SwiftUI

extension ActualReading {
	func deleteBook(_ book: NowReading) {
		if book.sessions.isEmpty == false {
			bookToDelete = book
			showingDeletingAlert = true
		} else {
			model.userLogic.removeFromWaiting(book)
		}
	}
	
	func deleteBookAndSessions(_ book: NowReading) {
		book.sessions.forEach { session in
			model.userLogic.user.sessions.removeAll(where: { $0 == session })
		}
		model.userLogic.removeFromWaiting(book)
	}
	
	struct ActualReadingModifer: ViewModifier {
		@EnvironmentObject var model: GlobalViewModel
		@Binding var showingDeletingAlert: Bool
		@Binding var showingAddNewBook: Bool
		
		let book: NowReading
		let deleteBookAndSessions: (NowReading) -> Void
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Leyendo... y en espera")
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button {
							showingAddNewBook = true
						} label: {
							Label("Añadir libro", systemImage: "doc.badge.plus")
						}
					}
				}
				.alert("¡Atención!\nEstás intentando borrar un libro con datos de lectura.", isPresented: $showingDeletingAlert) {
					Button("Cancelar", role: .cancel) { }
					Button("Mantener sesiones") {
						model.userLogic.removeFromWaiting(book)
					}
					Button("Borrar sesiones") {
						deleteBookAndSessions(book)
					}
				} message: {
					Text("¿Deseas mantener los datos de lectura o borrarlos?")
				}
				.sheet(isPresented: $showingAddNewBook) {
					NavigationView {
						AddReading(bookTitle: "", synopsis: "", formatt: .paper)
					}
				}
		}
	}
}
