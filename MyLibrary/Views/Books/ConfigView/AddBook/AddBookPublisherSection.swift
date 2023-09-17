//
//  AddBookPublisherSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension AddBook {
	var publisherSection: some View {
		Section {
			VStack(alignment: .leading) {
				Text("Editorial:")
					.font(.subheadline)
				TextField("Introduce la editorial", text: $newPublisher)
					.font(.headline)
					.tag(1)
					.onSubmit { searchForExistingData(tag: 1, newPublisher) }
			}
			VStack(alignment: .leading) {
				Text("Ciudad:")
					.font(.subheadline)
				TextField("Introduce la ciudad", text: $newCity)
					.font(.headline)
					.tag(2)
					.onSubmit { searchForExistingData(tag: 2, newCity) }
			}
			HStack {
				VStack(alignment: .leading) {
					Text("Edición:")
						.font(.subheadline)
					TextField("", value: $newEdition, format: .number)
						.font(.headline)
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("Año:")
						.font(.subheadline)
					TextField("", value: $newYear, format: .number)
						.font(.headline)
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("Año escritura:")
						.font(.subheadline)
					TextField("", value: $newWritingYear, format: .number)
						.font(.headline)
				}
			}
			.keyboardType(.numberPad)
			.textFieldStyle(.roundedBorder)
			HStack {
				VStack(alignment: .leading) {
					Text("Encuadernación:")
						.font(.subheadline)
					Picker("Encuadernación", selection: $newCoverType) {
						ForEach(Cover.allCases, id: \.self) {
							Text($0.rawValue)
						}
					}
					.pickerStyle(.menu)
					.labelsHidden()
				}
				Spacer()
				VStack(alignment: .leading) {
					Text("ISBN:")
						.font(.subheadline)
					HStack {
						TextField("", value: $newISBN1, format: .number)
						TextField("", value: $newISBN2, format: .number)
						TextField("", value: $newISBN3, format: .number)
						TextField("", value: $newISBN4, format: .number)
						TextField("", value: $newISBN5, format: .number)
					}
					.keyboardType(.numberPad)
					.textFieldStyle(.roundedBorder)
				}
			}
		}
	}
}
