//
//  EBookStatsPriceSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EbookStatsView {
	var priceSection: some View {
		Section("Precio: \(model.userLogic.globalPrice(model.userLogic.user.ebooks).total, format: .currency(code: "eur"))") {
			let value = model.userLogic.priceForStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.userLogic.priceForStats(tag: statsSelection, text: pickerSelection).mean
			let globalMean = model.userLogic.globalPrice(model.userLogic.user.ebooks).mean
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
