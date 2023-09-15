//
//  EBookGridCell.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 14/9/23.
//

import SwiftUI

struct EBookGridCell: View {
	let ebook: EBooks
	var uiimage: UIImage? {
		if let cover = ebook.cover {
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
				Text(ebook.bookTitle)
					.modifier(RDCoverModifier(width: 100, height: 120, cornerRadius: 10, lineWidth: 4))
			}
			
			imageStatus(ebook)
				.foregroundColor(colorStatus(ebook.status))
				.offset(x: 15, y: -5)
		}
    }
}

struct EBookCell_Previews: PreviewProvider {
    static var previews: some View {
		EBookGridCell(ebook: EBooks.dataTest)
    }
}
