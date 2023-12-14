//
//  ChunkedByEditionYearView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByEditionYearView: View {
	@Environment(GlobalViewModel.self) var model
	
	var booksChunkedByEditionYear: [(Int, [Books])] {
		model.userLogic.activeBooks.sorted { $0.editionYear < $1.editionYear }.chunked(on: \.editionYear)
			.map { ($0, Array($1)) }
	}
	
	var body: some View {
		List {
			if !booksChunkedByEditionYear.isEmpty {
				ForEach(booksChunkedByEditionYear, id: \.0) { editionYear in
					DisclosureGroup {
						ForEach(editionYear.1) { book in
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
							Image(systemName: "calendar")
								.foregroundStyle(.green)
							Text("Año \(String(editionYear.0)) (\(editionYear.1.count))")
						}
					}
				}
			} else {
				ContentUnavailableView("No se han encontrado resultados", systemImage: "magnifyingglass")
			}
		}
		.navigationTitle("Año de edición")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
    ChunkedByEditionYearView()
		.environment(GlobalViewModel.preview)
}
