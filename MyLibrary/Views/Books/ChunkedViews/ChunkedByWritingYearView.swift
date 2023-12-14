//
//  ChunkedByWritingYearView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByWritingYearView: View {
	@Environment(GlobalViewModel.self) var model
	
	var booksChunkedByWritingYear: [(Int, [Books])] {
		model.userLogic.activeBooks.sorted { $0.writingYear < $1.writingYear }.chunked(on: \.writingYear)
			.map { ($0, Array($1)) }
	}
	
	var body: some View {
		List {
			if !booksChunkedByWritingYear.isEmpty {
				ForEach(booksChunkedByWritingYear, id: \.0) { writingYear in
					DisclosureGroup {
						ForEach(writingYear.1) { book in
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
							Image(systemName: "calendar.badge.clock")
								.foregroundStyle(.purple)
							Text("Año \(String(writingYear.0)) (\(writingYear.1.count))")
						}
					}
				}
			} else {
				ContentUnavailableView("No se han encontrado resultados", systemImage: "magnifyingglass")
			}
		}
		.navigationTitle("Año de escritura")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
    ChunkedByWritingYearView()
		.environment(GlobalViewModel.preview)
}
