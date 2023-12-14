//
//  ChunkedByAuthorView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByAuthorView: View {
	@Environment(GlobalViewModel.self) var model
	
	var booksByAuthorByLetter: [(String, [(String, [Books])])] {
		let chunkedByAuthor = model.userLogic.activeBooks.sorted { $0.author < $1.author }
		// .map para transformar a [(String, [Books])]
			.chunked(on: \.author).map { ($0, Array($1)) }
		
		let chunkedByLetter = chunkedByAuthor.chunked(on: \.0.first!)
		// .map para transformar a [(String, [(String, [Books])])]
		return chunkedByLetter.map { (String($0), Array($1)) }
	}
	
    var body: some View {
		List {
			if !booksByAuthorByLetter.isEmpty {
				ForEach(booksByAuthorByLetter, id: \.0) { authorsByLetter in
					DisclosureGroup {
						ForEach(authorsByLetter.1, id: \.0) { booksByAuthor in
							DisclosureGroup {
								ForEach(booksByAuthor.1) { book in
									NavigationLink(destination: BookDetail(book: book)) {
										HStack {
											Image(systemName: book.status.iconName)
												.foregroundStyle(book.status.iconColor)
											Text(book.bookTitle)
										}
									}
								}
							} label: {
								Label("\(booksByAuthor.0) (\(booksByAuthor.1.count))", systemImage: "person.circle")
							}
						}
					} label: {
						Text("\(authorsByLetter.0) (\(authorsByLetter.1.count))")
					}
				}
			} else {
				ContentUnavailableView("No se han encontrado resultados", systemImage: "magnifyingglass")
			}
		}
		.navigationTitle("Autor")
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChunkedByAuthorView()
		.environment(GlobalViewModel.preview)
}
