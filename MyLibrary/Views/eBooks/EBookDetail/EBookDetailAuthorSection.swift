//
//  EBookDetailAuthorSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EBookDetail {
	var authorSection: some View {
		Section {
			HStack {
				VStack(alignment: .leading) {
					Text("Autor:")
						.font(.subheadline)
					Text(ebook.author)
						.font(.headline)
				}
				Spacer()
				Button {
					titleInfoAlert = ebook.status.infoAlert.title
					messageInfoAlert = ebook.status.infoAlert.message
					showingInfoAlert = true
				} label: {
					Image(systemName: ebook.status.iconName)
						.font(.title)
						.foregroundColor(ebook.status.iconColor)
				}
				.buttonStyle(.bordered)
			}
			VStack(alignment: .leading) {
				Text("Título:")
					.font(.subheadline)
				Text(ebook.bookTitle)
					.font(.headline)
			}
			VStack(alignment: .leading) {
				Text("Título original:")
					.font(.subheadline)
				Text(ebook.originalTitle)
					.font(.headline)
			}
		}
	}
}
