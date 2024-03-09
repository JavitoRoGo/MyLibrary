//
//  ActualReadingRow.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/3/22.
//

import SwiftUI

struct ActualReadingRow: View {
    let book: NowReading
    @State private var image: Image?
    
    var body: some View {
        HStack {
			if let image {
				image
					.resizable()
					.modifier(RDCoverModifier(width: 35, height: 50, cornerRadius: 5, lineWidth: 2))
			} else {
				Text(book.bookTitle)
					.modifier(RDCoverModifier(width: 35, height: 50, cornerRadius: 5, lineWidth: 2))
			}
                
            VStack(alignment: .leading) {
                Text(book.bookTitle)
                    .font(.title3)
                if !book.isFinished {
                    Text(book.isOnReading ? "Faltan \(book.remainingPages) páginas" : "\(book.pages) páginas")
                        .font(.caption)
                } else {
                    Text("Terminado")
                        .font(.caption)
                }
            }
            Spacer()
            ProgressRingMini(book: book)
        }
        .foregroundColor(book.isOnReading ? .primary : .secondary)
        .onAppear {
            let cover = imageCoverName(from: book.bookTitle)
			if let uiimage = getCoverImage(from: cover) {
				image = Image(uiImage: uiimage)
			}
        }
    }
}

struct ActualReadingRow_Previews: PreviewProvider {
    static var previews: some View {
        ActualReadingRow(book: NowReading.example[0])
            .previewLayout(.sizeThatFits)
    }
}
