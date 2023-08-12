//
//  AddEBookAuthorSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension AddEBook {
	var authorSection: some View {
		Section {
			VStack(alignment: .leading) {
				Text("Autor:")
					.font(.subheadline)
				TextField("Introduce el autor", text: $newAuthor)
					.font(.headline)
					.onSubmit { searchForExistingData(newAuthor) }
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
		}
	}
}
