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
		Section("Precio: \(model.userLogic.globalPrice(model.userLogic.user.books).total, format: .currency(code: "eur"))") {
			let value = model.userLogic.priceAtPlace(place).total
			let mean = model.userLogic.priceAtPlace(place).mean
			let globalMean = model.userLogic.globalPrice(model.userLogic.user.books).mean
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
