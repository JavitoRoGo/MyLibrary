//
//  EditPlacesSection1.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EditPlaces {
	var placesSection: some View {
		Section {
			ForEach(model.userLogic.user.myPlaces, id: \.self) { place in
				NavigationLink {
					VStack {
						Text("Cambia aquí el nombre de esta ubicación:")
						TextField(place, text: $newPlace)
							.padding()
							.textFieldStyle(.roundedBorder)
						Spacer()
					}
					.toolbar {
						Button("Modificar") {
							if let index = model.userLogic.user.myPlaces.firstIndex(of: place) {
								model.userLogic.user.myPlaces[index] = newPlace
								if model.userLogic.numberOfBooksAtPlace(place) != 0 {
									oldPlace = place
									showingEditAlert = true
								}
							}
						}
						.disabled(newPlace.isEmpty || place == soldText || place == donatedText)
					}
				} label: {
					Text(place)
				}
				.swipeActions(edge: .trailing) {
					Button(role: .destructive) {
						withAnimation {
							if model.userLogic.numberOfBooksAtPlace(place) == 0 {
								model.userLogic.user.myPlaces.removeAll(where: { $0 == place })
							} else {
								oldPlace = place
								showingDeleteAlert = true
							}
						}
					} label: {
						Label("Borrar", systemImage: "trash")
					}
					.disabled(place == soldText || place == donatedText)
				}
			}
			.onMove(perform: move)
		} header: {
			Text("Ubicaciones creadas")
		} footer: {
			Text("Se muestran los nombres de las ubicaciones creadas. Pulsa sobre una ubicación para editarla o desliza para borrarla.")
		}
	}
}
