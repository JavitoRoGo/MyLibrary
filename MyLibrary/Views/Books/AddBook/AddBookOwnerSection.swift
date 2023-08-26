//
//  AddBookOwnerSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension AddBook {
	var ownerSection: some View {
		Section {
			HStack {
				VStack(alignment: .leading) {
					Text("Propietario:")
						.font(.subheadline)
					Picker("Propietario", selection: $newOwner) {
						ForEach(model.myOwners, id: \.self) {
							Text($0)
						}
					}
					.labelsHidden()
				}
				Spacer()
				VStack(alignment: .center) {
					Text("Estado:")
						.font(.subheadline)
					Picker("Estado", selection: $newStatus) {
						ForEach(ReadingStatus.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
					.labelsHidden()
				}
				Spacer()
				VStack(alignment: .center) {
					Text("Ubicación:")
						.font(.subheadline)
					Picker("Ubicación", selection: $newPlace) {
						ForEach(model.user.myPlaces, id: \.self) {
							Text($0)
						}
					}
					.labelsHidden()
				}
			}
			.pickerStyle(.menu)
		}
	}
}
