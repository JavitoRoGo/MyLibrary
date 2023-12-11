//
//  ChunkedByEditionView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByEditionView: View {
	@Environment(GlobalViewModel.self) var model
	
	var booksChunkedByEdition: [(Int, [Books])] {
		model.userLogic.activeBooks.sorted { $0.edition < $1.edition }.chunked(on: \.edition)
			.map { ($0, Array($1)) }
	}
	
    var body: some View {
		List {
			ForEach(booksChunkedByEdition, id: \.0) { edition in
				DisclosureGroup {
					ForEach(edition.1) { book in
						NavigationLink(destination: BookDetail(book: book)) {
							HStack {
								Image(systemName: book.status.iconName)
									.foregroundStyle(book.status.iconColor)
								Text(book.bookTitle)
							}
						}
					}
				} label: {
					HStack {
						Image(systemName: "number")
							.foregroundStyle(.orange)
						Text("\(edition.0)ª edición (\(edition.1.count))")
					}
				}
			}
		}
		.navigationTitle("Edición")
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChunkedByEditionView()
		.environment(GlobalViewModel.preview)
}
