//
//  BookRow.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct BookRow: View {
    let book: Books
    
    var body: some View {
        HStack {
            imageStatus(book)
                .font(.title)
                .foregroundColor(colorStatus(book.status))
            VStack(alignment: .leading) {
                Text(book.bookTitle)
                    .font(.title2)
                Text(book.author)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(book: Books.dataTest)
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
