//
//  ThicknessSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

// Subvistas y secciones que componen la vista
extension BookStats {
	var thicknessSection: some View {
		Section("Grosor (cm): \(model.userLogic.globalThickness().total, format: .number.precision(.fractionLength(1)))") {
			let value = model.userLogic.thicknessAtPlace(place).total
			let mean = model.userLogic.thicknessAtPlace(place).mean
			let globalMean = model.userLogic.globalThickness().mean
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
