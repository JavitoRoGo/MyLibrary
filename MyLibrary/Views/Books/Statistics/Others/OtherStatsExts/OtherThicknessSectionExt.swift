//
//  OtherThicknessSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension OtherStats {
	var thicknessSection: some View {
		Section("Grosor (cm): \(measureFormatter.string(from: NSNumber(value: model.globalThickness().total))!)") {
			let value = model.thicknessForOtherStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.thicknessForOtherStats(tag: statsSelection, text: pickerSelection).mean
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
