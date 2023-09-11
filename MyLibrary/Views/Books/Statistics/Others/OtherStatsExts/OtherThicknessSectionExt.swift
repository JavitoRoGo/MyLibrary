//
//  OtherThicknessSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension OtherStats {
	var thicknessSection: some View {
		Section("Grosor (cm): \(model.globalThickness().total, format: .number.precision(.fractionLength(1)))") {
			let value = model.thicknessForOtherStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.thicknessForOtherStats(tag: statsSelection, text: pickerSelection).mean
			let globalMean = model.globalThickness().mean
			let compare = compareWithMean(value: mean, mean: globalMean)
			HStack {
				VStack {
					Text("Total:")
						.font(.subheadline)
					Text(value, format: .number.precision(.fractionLength(1)))
						.font(.title2)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(mean, format: .number.precision(.fractionLength(1)))
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(globalMean, format: .number.precision(.fractionLength(1)))
						.font(.title2)
				}
			}
		}
	}
}
