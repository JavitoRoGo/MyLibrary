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
		Section("Peso (g): \(model.userLogic.globalWeight().total.formatted(.number))") {
			let value = model.userLogic.weightAtPlace(place).total
			let mean = model.userLogic.weightAtPlace(place).mean
			let globalMean = model.userLogic.globalWeight().mean
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
