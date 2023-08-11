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
		Section("Precio: \(priceFormatter.string(from: NSNumber(value: bmodel.globalPrice().total))!)") {
			let value = bmodel.priceAtPlace(place).total
			let mean = bmodel.priceAtPlace(place).mean
			let globalMean = bmodel.globalPrice().mean
			let compare = compareWithMean(value: mean, mean: globalMean)
			HStack {
				VStack {
					Text("Total:")
						.font(.subheadline)
					Text(priceFormatter.string(from: NSNumber(value: value))!)
						.font(.title2)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(priceFormatter.string(from: NSNumber(value: mean))!)
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(priceFormatter.string(from: NSNumber(value: globalMean))!)
						.font(.title2)
				}
			}
		}
	}
}
