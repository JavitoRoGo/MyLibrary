//
//  EBookStatsPagesSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EbookStatsView {
	var pagesSection: some View {
		Section("Número de páginas: \(model.globalPages().total)") {
			let value = model.numOfPagesForStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.numOfPagesForStats(tag: statsSelection, text: pickerSelection).mean
			let globalMean = model.globalPages().mean
			let compare = compareWithMean(value: Double(mean), mean: Double(globalMean))
			HStack {
				VStack {
					Text("Total:")
						.font(.subheadline)
					Text(noDecimalFormatter.string(from: NSNumber(value: value))!)
						.font(.title2)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(String(mean))
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(String(globalMean))
						.font(.title2)
				}
			}
		}
	}
}
