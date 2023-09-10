//
//  OtherWeightSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension OtherStats {
	var weightSection: some View {
		Section("Peso (g): \(model.globalWeight().total)") {
			let value = model.weightForOtherStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.weightForOtherStats(tag: statsSelection, text: pickerSelection).mean
			let globalMean = model.globalWeight().mean
			let compare = compareWithMean(value: Double(mean), mean: Double(globalMean))
			HStack {
				VStack {
					Text("Total:")
						.font(.subheadline)
					Text(value.formatted(.number))
						.font(.title2)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(mean.formatted(.number))
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(globalMean.formatted(.number))
						.font(.title2)
				}
			}
		}
	}
}
