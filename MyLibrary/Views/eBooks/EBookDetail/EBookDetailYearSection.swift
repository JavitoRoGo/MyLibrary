//
//  EBookDetailYearSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EBookDetail {
	var yearSection: some View {
		Section {
			HStack {
				VStack {
					Text("Año:")
						.font(.subheadline)
					Text(String(ebook.year))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Páginas:")
						.font(.subheadline)
					Text(String(ebook.pages))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Precio:")
						.font(.subheadline)
					Text(priceFormatter.string(from: NSNumber(value: ebook.price))!)
						.font(.headline)
				}
			}
		}
	}
}
