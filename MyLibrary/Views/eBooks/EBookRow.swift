//
//  EBookRow.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookRow: View {
    let ebook: EBooks
    
    var body: some View {
        HStack {
			Image(systemName: ebook.status.iconName)
                .font(.title)
				.foregroundColor(ebook.status.iconColor)
            VStack(alignment: .leading) {
                Text(ebook.bookTitle)
                    .font(.title2)
                Text(ebook.author)
            }
            .padding(.leading, 5)
            Spacer()
        }
    }
}

struct EBookRow_Previews: PreviewProvider {
    static var previews: some View {
        EBookRow(ebook: EBooks.dataTest)
            .previewLayout(.fixed(width: 400, height: 90))
    }
}
