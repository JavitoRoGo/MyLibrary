//
//  RDDetailCompareSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension RDDetail {
	var compareSection: some View {
		Section {
			HStack {
				let value = minPerPagInMinutes(rdata.minPerPag)
				let mean = model.meanMinPerPag
				let compare = compareWithMean(value: mean, mean: value)
				
				VStack {
					Text("min/pág:")
						.font(.subheadline)
					Text(rdata.minPerPag)
						.font(.headline)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(minPerPagDoubleToString(mean))
						.font(.headline)
				}
				Spacer()
				Image(systemName: compare.image)
					.foregroundColor(compare.color)
					.font(.title)
			}
			HStack {
				let value = minPerDayInHours(rdata.minPerDay)
				let mean = model.meanMinPerDay
				let compare = compareWithMean(value: value, mean: mean)
				
				VStack {
					Text("min/día:")
						.font(.subheadline)
					Text(rdata.minPerDay)
						.font(.headline)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(minPerDayDoubleToString(mean))
						.font(.headline)
				}
				Spacer()
				Image(systemName: compare.image)
					.foregroundColor(compare.color)
					.font(.title)
			}
			HStack {
				let value = rdata.pagPerDay
				let mean = model.meanPagPerDay
				let compare = compareWithMean(value: value, mean: mean)
				
				VStack {
					Text("pág/día:")
						.font(.subheadline)
					Text(value, format: .number)
						.font(.headline)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(noDecimalFormatter.string(from: NSNumber(value: mean))!)
						.font(.headline)
				}
				Spacer()
				Image(systemName: compare.image)
					.foregroundColor(compare.color)
					.font(.title)
			}
			HStack {
				let value = rdata.percentOver50
				let mean = model.meanOver50
				let compare = compareWithMean(value: value, mean: mean)
				
				VStack {
					Text(">50 (%):")
						.font(.subheadline)
					Text(noDecimalFormatter.string(from: NSNumber(value: value))! + "%")
						.font(.headline)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(noDecimalFormatter.string(from: NSNumber(value: mean))! + "%")
						.font(.headline)
				}
				Spacer()
				Image(systemName: compare.image)
					.foregroundColor(compare.color)
					.font(.title)
			}
		}
	}
}
