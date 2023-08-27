//
//  WeightSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

// Subvistas y secciones que componen la vista
extension BookStats {
	var weightSection: some View {
		Section("Peso (g): \(noDecimalFormatter.string(from: NSNumber(value: model.globalWeight().total))!)") {
			let value = model.weightAtPlace(place).total
			let mean = model.weightAtPlace(place).mean
			let globalMean = model.globalWeight().mean
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
					Text(noDecimalFormatter.string(from: NSNumber(value: mean))!)
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(noDecimalFormatter.string(from: NSNumber(value: globalMean))!)
						.font(.title2)
				}
			}
		}
	}
}
