//
//  BooksGridCell.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/9/23.
//

import SwiftUI

struct BooksGridCell: View {
	let book: Books
	var uiimage: UIImage? {
		if let cover = book.cover {
			return getCoverImage(from: cover)
		} else {
			return nil
		}
	}
	
	var body: some View {
		ZStack(alignment: .topTrailing) {
			if let uiimage {
				Image(uiImage: uiimage)
					.resizable()
					.modifier(RDCoverModifier(width: 100, height: 120, cornerRadius: 10, lineWidth: 4))
			} else {
				Text(book.bookTitle)
					.modifier(RDCoverModifier(width: 100, height: 120, cornerRadius: 10, lineWidth: 4))
			}
			
			Image(systemName: book.status.iconName)
				.foregroundColor(book.status.iconColor)
				.offset(x: 15, y: -5)
		}
		.padding(.bottom)
	}
}

struct BooksGridCell_Previews: PreviewProvider {
    static var previews: some View {
		BooksGridCell(book: Books.example[0])
    }
}
