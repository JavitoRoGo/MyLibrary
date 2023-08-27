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
		Section("Grosor (cm): \(measureFormatter.string(from: NSNumber(value: model.globalThickness().total))!)") {
			let value = model.thicknessAtPlace(place).total
			let mean = model.thicknessAtPlace(place).mean
			let globalMean = model.globalThickness().mean
			let compare = compareWithMean(value: mean, mean: globalMean)
			HStack {
				VStack {
					Text("Total:")
						.font(.subheadline)
					Text(measureFormatter.string(from: NSNumber(value: value))!)
						.font(.title2)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(measureFormatter.string(from: NSNumber(value: mean))!)
						.font(.title2)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Global:")
						.font(.subheadline)
					Text(measureFormatter.string(from: NSNumber(value: globalMean))!)
						.font(.title2)
				}
			}
		}
	}
}
