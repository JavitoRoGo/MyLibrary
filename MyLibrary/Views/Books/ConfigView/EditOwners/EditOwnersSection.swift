//
//  EditOwnersSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EditOwners {
	var ownersSection: some View {
		Section {
			ForEach(model.user.myOwners, id: \.self) { owner in
				NavigationLink {
					VStack {
						Text("Cambia aquí el nombre de esta persona:")
						TextField(owner, text: $newOwner)
							.padding()
							.textFieldStyle(.roundedBorder)
						Spacer()
					}
					.toolbar {
						Button("Modificar") {
							if let index = model.user.myOwners.firstIndex(of: owner) {
								model.user.myOwners[index] = newOwner
								if model.numberOfBooksByOwner(owner) != 0 || model.numberOfEbooksByOwner(owner) != 0 {
									oldOwner = owner
									showingEditAlert = true
								}
							}
						}
						.disabled(newOwner.isEmpty)
					}
				} label: {
					Text(owner)
				}
				.swipeActions(edge: .trailing) {
					Button(role: .destructive) {
						withAnimation {
							if model.numberOfBooksByOwner(owner) == 0 && model.numberOfEbooksByOwner(owner) == 0 {
								model.user.myOwners.removeAll(where: { $0 == owner })
							} else {
								oldOwner = owner
								showingDeleteAlert = true
							}
						}
					} label: {
						Label("Borrar", systemImage: "trash")
					}
				}
			}
			.onMove(perform: move)
		} header: {
			Text("Propietarios creados")
		} footer: {
			Text("Se muestran los nombres de los propietarios creados. Pulsa sobre un nombre para editarlo o desliza para borrarlo.")
		}
	}
}
