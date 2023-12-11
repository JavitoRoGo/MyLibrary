//
//  ChunkedByPublisherView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByPublisherView: View {
	@Environment(GlobalViewModel.self) var model
	
	var booksByPublisherByLetter: [(String, [(String, [Books])])] {
		let chunkedByPublisher = model.userLogic.activeBooks.sorted { $0.publisher < $1.publisher }.chunked(on: \.publisher)
		// .map para transformar a [(String, [Books])]
			.map { ($0, Array($1)) }
		
		let chunkedByLetter = chunkedByPublisher.chunked(on: \.0.first!)
		// .map para transformar a [(String, [(String, [Books])])]
		return chunkedByLetter.map { (String($0), Array($1)) }
	}
	
	var body: some View {
		List {
			ForEach(booksByPublisherByLetter, id: \.0) { publishersByLetter in
				DisclosureGroup {
					ForEach(publishersByLetter.1, id: \.0) { booksByPublisher in
						DisclosureGroup {
							ForEach(booksByPublisher.1) { book in
								NavigationLink(destination: BookDetail(book: book)) {
									HStack {
										Image(systemName: book.status.iconName)
											.foregroundStyle(book.status.iconColor)
										Text(book.bookTitle)
									}
								}
							}
						} label: {
							Label("\(booksByPublisher.0) (\(booksByPublisher.1.count))", systemImage: "building.columns")
						}
					}
				} label: {
					Text("\(publishersByLetter.0) (\(publishersByLetter.1.count))")
				}
			}
		}
		.navigationTitle("Editorial")
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
    ChunkedByPublisherView()
		.environment(GlobalViewModel.preview)
}
