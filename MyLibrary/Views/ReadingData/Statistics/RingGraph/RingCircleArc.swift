//
//  RingCircleArc.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/4/22.
//

import Charts
import SwiftUI

struct SectorChartData: Identifiable {
	let id = UUID()
	let label: String
	let data: Int
	let color: Color
}

struct RingCircleArc: View {
	let sectorChartDatas: [SectorChartData]
	let tag: Int
	
	@State private var selectedCount: Int?
	@State private var selectedSector: SectorChartData?
	
	var body: some View {
        VStack{
			Chart(sectorChartDatas) { singleData in
				SectorMark(
					angle: .value("Valores", singleData.data),
					innerRadius: .ratio(0.65),
					outerRadius: selectedSector?.label == singleData.label ? 175 : 150,
					angularInset: 2
				)
				.foregroundStyle(singleData.color)
				.cornerRadius(10)
			}
			.chartAngleSelection(value: $selectedCount)
			.chartBackground { _ in
				if let selectedSector {
					VStack {
						Image(systemName: "books.vertical.fill")
							.font(.largeTitle)
							.foregroundStyle(.secondary)
						Text(selectedSector.label)
						Text("\(selectedSector.data) \(tag == 2 ? "pág/d" : (tag == 1 ? "páginas" : (selectedSector.data == 1 ? "libro" : "libros")))")
					}
				} else {
					VStack {
						Image(systemName: "chart.pie.fill")
							.font(.largeTitle)
							.foregroundStyle(.secondary)
						Text("Pulsa sobre un sector")
					}
				}
			}
			.frame(height: 350)
        }
		.onChange(of: selectedCount) { _, newValue in
			if let newValue {
				withAnimation {
					getSelectedSectorFor(value: newValue)
				}
			}
		}
		.onChange(of: tag) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				withAnimation {
					selectedSector = nil
				}
			}
		}
    }
	
	func getSelectedSectorFor(value: Int) {
		var total = 0
		let _ = sectorChartDatas.first { sector in
			total += sector.data
			if value <= total {
				selectedSector = sector
				return true
			} else {
				return false
			}
		}
	}
}

struct RingCircleArc_Previews: PreviewProvider {
    static let datas: [SectorChartData] = [
		.init(label: "10", data: 10, color: .red),
		.init(label: "20", data: 20, color: .orange),
		.init(label: "30", data: 30, color: .green),
		.init(label: "40", data: 40, color: .blue),
		.init(label: "50", data: 50, color: .purple)
	]
    
    static var previews: some View {
		RingCircleArc(sectorChartDatas: datas, tag: 0)
    }
}
