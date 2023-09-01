//
//  EditOwnersExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EditOwners {
	func move(from source: IndexSet, to destination: Int) {
		model.myOwners.move(fromOffsets: source, toOffset: destination)
	}
	
	// View modifier para la lista de owners
	struct OwnersListModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		
		@Binding var oldOwner: String
		@Binding var newOwner: String
		@Binding var showingAddOwner: Bool
		@Binding var showingEditOwner: Bool
		@Binding var showingDeleteAlert: Bool
		@Binding var showingEditAlert: Bool
		
		func body(content: Content) -> some View {
			content
				.toolbar {
					EditButton()
						.disabled(showingAddOwner || showingEditOwner)
				}
				.alert("Esta persona tiene libros o ebooks registrados.\n¿Deseas borrarla de todas formas?", isPresented: $showingDeleteAlert) {
					Button("No", role: .cancel) { }
					Button("Sí", role: .destructive) {
						model.myOwners.removeAll(where: { $0 == oldOwner })
						model.changeBookOwnerFromTo(from: oldOwner, to: "sin asignar")
						model.changeEbookOwnerFromTo(from: oldOwner, to: "sin asignar")
						oldOwner = ""
					}
				} message: {
					Text("Esto NO borrará los libros o ebooks registrados.")
				}
				.alert("Se ha modificado el nombre de esta persona.", isPresented: $showingEditAlert) {
					Button("No", role: .cancel) { }
					Button("Sí") {
						model.changeBookOwnerFromTo(from: oldOwner, to: newOwner)
						model.changeEbookOwnerFromTo(from: oldOwner, to: newOwner)
						newOwner = ""
					}
				} message: {
					Text("¿Quieres cambiar también el propietario en todos los registros?")
				}
		}
	}
	
	// View modifier para la vista global
	struct EditOwnersModifier: ViewModifier {
		@Binding var showingAddOwner: Bool
		@Binding var showingEditOwner: Bool
		
		func body(content: Content) -> some View {
			content
				.autocorrectionDisabled()
				.navigationTitle("Propietarios")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button() {
							showingAddOwner = true
						} label: {
							Label("Añadir", systemImage: "plus")
						}
						.disabled(showingAddOwner || showingEditOwner)
					}
				}
		}
	}
}
