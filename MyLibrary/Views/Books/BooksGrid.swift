//
//  BooksGrid.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/9/23.
//

import SwiftUI

struct BooksGrid: View {
	let books: [Books]
	let columns = [GridItem(.adaptive(minimum: 100))]
	
	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(books) { book in
					NavigationLink(destination: BookDetail(book: book)) {
						BooksGridCell(book: book)
					}
				}
			}
		}
		.padding(.horizontal, 10)
	}
}

struct BooksGrid_Previews: PreviewProvider {
    static var previews: some View {
		BooksGrid(books: [Books.dataTest])
    }
}
