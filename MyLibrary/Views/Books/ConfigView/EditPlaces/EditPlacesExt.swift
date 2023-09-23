//
//  EditPlacesExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EditPlaces {
	func move(from source: IndexSet, to destination: Int) {
		model.userLogic.user.myPlaces.move(fromOffsets: source, toOffset: destination)
	}
	
	// View modifier para la lista con places
	struct PlacesListModifier: ViewModifier {
		@EnvironmentObject var model: GlobalViewModel
		
		@Binding var oldPlace: String
		@Binding var newPlace: String
		@Binding var showingAddPlace: Bool
		@Binding var showingEditPlace: Bool
		@Binding var showingDeleteAlert: Bool
		@Binding var showingEditAlert: Bool
		
		func body(content: Content) -> some View {
			content
				.toolbar {
					EditButton()
						.disabled(showingAddPlace || showingEditPlace)
				}
				.alert("Esta ubicación tiene libros registrados.\n¿Deseas borrarla de todas formas?", isPresented: $showingDeleteAlert) {
					Button("No", role: .cancel) { }
					Button("Sí", role: .destructive) {
						model.userLogic.user.myPlaces.removeAll(where: { $0 == oldPlace })
						model.userLogic.moveFromTo(from: oldPlace, to: "sin asignar")
						oldPlace = ""
					}
				} message: {
					Text("Esto NO borrará los libros registrados.")
				}
				.alert("Se ha modificado el nombre de esta ubicación.", isPresented: $showingEditAlert) {
					Button("No", role: .cancel) { }
					Button("Sí") {
						model.userLogic.moveFromTo(from: oldPlace, to: newPlace)
						newPlace = ""
					}
				} message: {
					Text("¿Quieres cambiar también la ubicación en todos los registros?")
				}
		}
	}
	
	// View modifier para la vista global
	struct EditPlacesModifier: ViewModifier {
		@Binding var showingAddPlace: Bool
		@Binding var showingEditPlace: Bool
		
		func body(content: Content) -> some View {
			content
				.autocorrectionDisabled()
				.navigationTitle("Ubicaciones")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button() {
							showingAddPlace = true
						} label: {
							Label("Añadir", systemImage: "plus")
						}
						.disabled(showingAddPlace || showingEditPlace)
					}
				}
		}
	}
}
