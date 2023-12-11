//
//  ChunkedByWritingYear.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByWritingYear: View {
	@Environment(GlobalViewModel.self) var model
	
	var booksChunkedByWritingYear: [(Int, [Books])] {
		model.userLogic.activeBooks.sorted { $0.writingYear < $1.writingYear }.chunked(on: \.writingYear)
			.map { ($0, Array($1)) }
	}
	
	var body: some View {
		List {
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
		}
		.navigationTitle("Año de escritura")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
    ChunkedByWritingYear()
		.environment(GlobalViewModel.preview)
}
