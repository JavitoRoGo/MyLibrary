//
//  OtherPriceSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension OtherStats {
	var priceSection: some View {
		Section("Precio: \(priceFormatter.string(from: NSNumber(value: model.globalPrice(model.user.books).total))!)") {
			let value = model.priceForOtherStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.priceForOtherStats(tag: statsSelection, text: pickerSelection).mean
			let globalMean = model.globalPrice(model.user.books).mean
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
