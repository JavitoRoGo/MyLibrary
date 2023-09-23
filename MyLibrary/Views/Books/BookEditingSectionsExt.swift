//
//  BookEditingSectionsExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 16/9/23.
//

import SwiftUI

extension BookEditing {
	var pickers: some View {
		Section {
			HStack {
				VStack(alignment: .leading) {
					Text("Estado:")
						.font(.subheadline)
					Picker("Estado", selection: $newStatus) {
						ForEach(ReadingStatus.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
					.labelsHidden()
					.pickerStyle(.menu)
				}
				Spacer()
				VStack(alignment: .center) {
					Text("Ubicación:")
						.font(.subheadline)
					Picker("Ubicación", selection: $newPlace) {
						ForEach(model.userLogic.user.myPlaces, id: \.self) {
							Text($0)
						}
					}
					.labelsHidden()
					.pickerStyle(.menu)
				}
				Spacer()
				VStack(alignment: .center) {
					Text("Propietario:")
						.font(.subheadline)
					Picker("Propietario", selection: $newOwner) {
						ForEach(model.userLogic.user.myOwners, id: \.self) {
							Text($0)
						}
					}
					.labelsHidden()
					.pickerStyle(.menu)
				}
			}
		}
	}
	
	var imageSelector: some View {
		VStack(alignment: .center, spacing: 15) {
			Button {
				showingCoverSelection = true
			} label: {
				if inputImage != nil {
					Text("Cambiar portada")
				} else {
					Text("Añadir portada")
				}
			}
			.buttonStyle(.borderedProminent)
			
			if let inputImage {
				HStack {
					Image(uiImage: inputImage)
						.resizable()
						.scaledToFit()
						.frame(height: 150)
					Button {
						self.inputImage = nil
					} label: {
						Image(systemName: "xmark.circle")
							.foregroundColor(.secondary)
					}
				}
				.offset(x: 18)
			}
		}
	}
}
