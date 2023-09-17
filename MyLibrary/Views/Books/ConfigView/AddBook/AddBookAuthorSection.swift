//
//  AddBookAuthorSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension AddBook {
	var authorSection: some View {
		Section {
			VStack(alignment: .leading) {
				Text("Autor:")
					.font(.subheadline)
				TextField("Introduce el autor", text: $newAuthor)
					.font(.headline)
					.tag(0)
					.onSubmit { searchForExistingData(tag: 0, newAuthor) }
			}
			VStack(alignment: .leading) {
				Text("Título:")
					.font(.subheadline)
				TextField("Introduce el título", text: $newBookTitle)
					.font(.headline)
					.textInputAutocapitalization(.never)
			}
			VStack(alignment: .leading) {
				Text("Título original:")
					.font(.subheadline)
				TextField("Introduce el título original", text: $newOriginalTitle)
					.font(.headline)
					.textInputAutocapitalization(.never)
			}
			HStack {
				Button("Añadir portada") {
					showingCoverSelection = true
				}
				.buttonStyle(.plain)
				.foregroundColor(.blue)
				Spacer()
				if let inputImage {
					Image(uiImage: inputImage)
						.resizable()
						.scaledToFit()
						.frame(height: 50)
					Button {
						self.inputImage = nil
					} label: {
						Image(systemName: "xmark.circle")
							.foregroundColor(.secondary)
					}
					
				}
			}
		}
	}
}
