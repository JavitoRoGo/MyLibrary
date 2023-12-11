//
//  ChunkedByPagesView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByPagesView: View {
	@Environment(GlobalViewModel.self) var model
	
	let ranges = [1...100, 101...200, 201...300, 301...400, 401...500, 501...600, 601...700, 701...800, 801...900, 901...1000]
	
	var booksChunkedByPages: [[Books]] {
		var books = [[Books]]()
		for range in ranges {
			let filtered = model.userLogic.activeBooks.filter { range.contains($0.pages) }
			books.append(filtered)
		}
		
		return books
	}
	
	var booksOver1000Pages: [Books] {
		model.userLogic.activeBooks.filter { $0.pages > 1000 }
	}
	
    var body: some View {
		List {
			ForEach(ranges.indices, id: \.self) { index in
				DisclosureGroup {
					ForEach(booksChunkedByPages[index]) { book in
						NavigationLink(destination: BookDetail(book: book)) {
							HStack {
								Image(systemName: book.status.iconName)
									.foregroundStyle(book.status.iconColor)
								Text(book.bookTitle)
							}
						}
					}
				} label: {
					Label("\(ranges[index].first!)-\(ranges[index].last!) (\(booksChunkedByPages[index].count))",
						  systemImage: "123.rectangle.fill")
					.foregroundStyle(.primary)
				}
			}
			DisclosureGroup {
				ForEach(booksOver1000Pages) { book in
					NavigationLink(destination: BookDetail(book: book)) {
						HStack {
							Image(systemName: book.status.iconName)
								.foregroundStyle(book.status.iconColor)
							Text(book.bookTitle)
						}
					}
				}
			} label: {
				Label("> 1000 (\(booksOver1000Pages.count))", systemImage: "123.rectangle.fill")
					.foregroundStyle(.primary)
			}
		}
		.navigationTitle("Páginas")
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChunkedByPagesView()
		.environment(GlobalViewModel.preview)
}
