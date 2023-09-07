//
//  PriceSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

// Subvistas y secciones que componen la vista
extension BookStats {
	var priceSection: some View {
		Section("Precio: \(model.globalPrice(model.user.books).total, format: .currency(code: "eur"))") {
			let value = model.priceAtPlace(place).total
			let mean = model.priceAtPlace(place).mean
			let globalMean = model.globalPrice(model.user.books).mean
			let compare = compareWithMean(value: mean, mean: globalMean)
			HStack {
				VStack {
					Text("Total:")
						.font(.subheadline)
					Text(value, format: .currency(code: "eur"))
						.font(.title2)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(mean, format: .currency(code: "eur"))
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(globalMean, format: .currency(code: "eur"))
						.font(.title2)
				}
			}
		}
	}
}
