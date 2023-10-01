//
//  OtherPagesSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension OtherStats {
	var pagesSection: some View {
		Section("Número de páginas: \(model.userLogic.globalPages(model.userLogic.user.books).total)") {
			let value = model.userLogic.numOfPagesForOtherStats(tag: statsSelection, text: pickerSelection).total
			let mean = model.userLogic.numOfPagesForOtherStats(tag: statsSelection, text: pickerSelection).mean
			let globalMean = model.userLogic.globalPages(model.userLogic.user.books).mean
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
