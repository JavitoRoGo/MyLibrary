//
//  NewBarGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import Charts
import SwiftUI

struct NewBarGraph: View {
	@EnvironmentObject var preferences: UserPreferences
	
	let datas: [Double]
	let labels: [String]
	
	@State private var newDatas: [DataStructForAnimateGraph<Double,String>] = []
	
	var body: some View {
		ScrollView {
			Chart(newDatas) { data in
				BarMark(
					x: .value("Páginas", data.animate ? data.value : 0),
					y: .value("Día", data.label)
				)
				.foregroundStyle(data.value < Double(preferences.dailyPagesTarget) ? .blue : .green)
				.annotation(position: .trailing) {
					Text(data.value.formatted())
						.font(.caption)
						.foregroundColor(.secondary)
				}
			}
			.padding()
			.chartPlotStyle { plot in
				plot.background(.blue.opacity(0.1))
					.frame(height: 40 * CGFloat(newDatas.count))
			}
			.chartXAxis {
				AxisMarks(position: .top)
			}
		}
		.task {
			newDatas = getValuesIntoDataArrayForAnimateGraph(datas, labels)
			animateGraph(true)
		}
	}
	
	func animateGraph(_ fromChange: Bool = false) {
		for (index, _) in newDatas.enumerated() {
			DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
				withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
					newDatas[index].animate = true
				}
			}
		}
	}
}
