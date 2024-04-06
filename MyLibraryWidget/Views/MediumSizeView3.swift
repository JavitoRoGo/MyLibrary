//
//  MediumSizeView3.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 19/1/23.
//

import Charts
import SwiftUI
import WidgetKit

struct MediumSizeView3: View {
    var entry: SimpleEntry
    
    var body: some View {
        Group {
        	if entry.data.sessions.isEmpty {
				Text("Fija tus objetivos de lectura y empieza a leer.")
					.font(.title3)
					.padding(.horizontal)
			} else {
				VStack(spacing: 25) {
					Text("Objetivos").font(.title3.bold())
					HStack(spacing: 25) {
						VStack(spacing: 15) {
							RingTargetView(color: .red, value: entry.data.read.dailyPages, target: entry.data.targets.dailyPages)
							Text("Diario")
						}
						VStack(spacing: 15) {
							RingTargetView(color: .orange, value: entry.data.read.weeklyPages, target: entry.data.targets.weeklyPages)
							Text("Semanal")
						}
						VStack(spacing: 15) {
							RingTargetView(color: .green, value: entry.data.read.monthlyBooks, target: entry.data.targets.monthlyBooks)
							Text("Mensual")
						}
						VStack(spacing: 15) {
							RingTargetView(color: .blue, value: entry.data.read.yearlyBooks, target: entry.data.targets.yearlyBooks)
							Text("Anual")
						}
					}
					.font(.caption)
				}
			}
        }
		.containerBackground(for: .widget, alignment: .center) { }
    }
}

struct MediumSizeView3_Previews: PreviewProvider {
    static var previews: some View {
        MediumSizeView3(entry: SimpleEntry(date: .now, data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
