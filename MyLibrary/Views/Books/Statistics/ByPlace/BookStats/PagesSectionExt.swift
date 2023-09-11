//
//  PagesSectionExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

// Subvistas y secciones que componen la vista
extension BookStats {
	var pagesSection: some View {
		Section("Número de páginas: \(model.globalPages(model.user.books).total.formatted(.number))") {
			let value = model.pagesAtPlace(place).total
			let mean = model.pagesAtPlace(place).mean
			let globalMean = model.globalPages(model.user.books).mean
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
