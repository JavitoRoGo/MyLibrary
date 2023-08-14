//
//  AddEBookYearSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension AddEBook {
	var yearSection: some View {
		Section {
			HStack {
				VStack(alignment: .leading) {
					Text("Año:")
						.font(.subheadline)
					TextField("", value: $newYear, format: .number)
						.font(.headline)
				}
				Spacer()
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
					TextField("", value: $newPrice, format: .number)
						.font(.headline)
				}
			}
			.textFieldStyle(.roundedBorder)
			.keyboardType(.numberPad)
		}
	}
}
