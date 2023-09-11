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
				let value = rdata.minPerPag.minPerPagInMinutes
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
					Text(mean.minPerPagDoubleToString)
						.font(.headline)
				}
				Spacer()
				Image(systemName: compare.image)
					.foregroundColor(compare.color)
					.font(.title)
			}
			HStack {
				let value = rdata.minPerDay.minPerDayInHours
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
					Text(mean.minPerDayDoubleToString)
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
					Text(value, format: .number.precision(.fractionLength(0)))
						.font(.headline)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(mean.formatted(.number.precision(.fractionLength(0))))
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
					Text(value.formatted(.number.precision(.fractionLength(0))) + "%")
						.font(.headline)
						.foregroundColor(compare.color)
				}
				Spacer()
				VStack {
					Text("Promedio:")
						.font(.subheadline)
					Text(mean.formatted(.number.precision(.fractionLength(0))) + "%")
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
