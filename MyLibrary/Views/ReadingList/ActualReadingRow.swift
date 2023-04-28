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
            image?
                .resizable()
                .frame(width: 35, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.white, lineWidth: 3)
                }
                .shadow(color: .gray, radius: 7)
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
            let uiimage = getCoverImage(from: cover)
            image = Image(uiImage: uiimage)
        }
    }
}

struct ActualReadingRow_Previews: PreviewProvider {
    static var previews: some View {
        ActualReadingRow(book: NowReading.example[0])
            .previewLayout(.sizeThatFits)
    }
}
