//
//  OldBarGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

struct OldBarGraph: View {
	@EnvironmentObject var preferences: UserPreferences
	let datas: [Double]
	let labels: [String]
	var maxData: Double {
		datas.max() ?? 0
	}
	
	var body: some View {
		GeometryReader { geo in
			ScrollView {
				ZStack {
					HStack(spacing: 15) {
						ForEach(getGraphLines(), id: \.self) { line in
							VStack(spacing: 8) {
								Text(Int(line), format: .number)
									.font(.caption)
									.foregroundColor(.secondary)
									.frame(height: 20)
								Rectangle()
									.fill(.gray.opacity(0.2))
									.frame(width: 1)
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity)
							.offset(x: 15)
						}
					}
					
					HStack(spacing: 0) {
						VStack {
							ForEach(datas.indices, id: \.self) { index in
								Text(labels[index])
									.font(.caption)
									.foregroundColor(datas[index] >= Double(preferences.dailyPagesTarget) ? .green : .primary)
									.frame(width: 30, alignment: .leading)
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
						}
						.offset(x: 10)
						VStack(alignment: .leading) {
							ForEach(datas.indices, id:\.self) { index in
								AnimatedBarGraph(index: index, showOver50: showOver50(index: index))
									.frame(width: getBarWidth(point: datas[index], size: geo.size))
							}
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
						}
						.offset(x: -22)
					}
					.padding(.top, 30)
				}
			}
		}
	}
	
	func getGraphLines() -> [Double] {
		var lines: [Double] = []
		lines.append(maxData)
		for index in 1...4 {
			let progress = maxData / 4
			lines.insert(maxData - (progress * Double(index)), at: 0)
		}
		return lines
	}
	
	func getBarWidth(point: Double, size: CGSize) -> Double {
		(point / maxData) * (size.width - 74)
	}
	
	func showOver50(index: Int) -> Bool {
		if datas[index] >= Double(preferences.dailyPagesTarget) {
			return true
		}
		return false
	}
}
