//
//  AddBookPhysicsSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension AddBook {
	var physicsSection: some View {
		Section {
			HStack {
				VStack(alignment: .leading) {
					Text("Páginas:")
						.font(.subheadline)
					TextField("", value: $newPages, format: .number)
						.font(.headline)
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("Precio:")
						.font(.subheadline)
					TextField("", value: $newPrice, format: .currency(code: "EUR"))
						.font(.headline)
						.keyboardType(.decimalPad)
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("Peso (g):")
						.font(.subheadline)
					TextField("", value: $newWeight, format: .number)
						.font(.headline)
				}
			}
			.keyboardType(.numberPad)
			HStack {
				VStack(alignment: .leading) {
					Text("Alto (cm):")
						.font(.subheadline)
					TextField("", value: $newHeight, format: .number)
						.font(.headline)
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("Ancho (cm):")
						.font(.subheadline)
					TextField("", value: $newWidth, format: .number)
						.font(.headline)
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("Grosor (cm):")
						.font(.subheadline)
					TextField("", value: $newThickness, format: .number)
						.font(.headline)
				}
			}
			.keyboardType(.decimalPad)
		}
		.textFieldStyle(.roundedBorder)
	}
}
