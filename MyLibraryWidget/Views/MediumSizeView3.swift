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
        if entry.data.sessions.isEmpty {
            Text("Fija tus objetivos de lectura y empieza a leer.")
                .font(.title3)
                .padding(.horizontal)
        } else {
            VStack(spacing: 25) {
                Text("Objetivos").font(.title3.bold())
                HStack(spacing: 25) {
                    VStack(spacing: 15) {
                        RingTargetView(color: .red, current: entry.data.read.dailyPages, target: entry.data.targets.dailyPages)
                            .frame(height: 65)
                        Text("Diario")
                    }
                    VStack(spacing: 15) {
                        RingTargetView(color: .orange, current: entry.data.read.weeklyPages, target: entry.data.targets.weeklyPages)
                            .frame(height: 65)
                        Text("Semanal")
                    }
                    VStack(spacing: 15) {
                        RingTargetView(color: .green, current: entry.data.read.monthlyBooks, target: entry.data.targets.monthlyBooks)
                            .frame(height: 65)
                        Text("Mensual")
                    }
                    VStack(spacing: 15) {
                        RingTargetView(color: .blue, current: entry.data.read.yearlyBooks, target: entry.data.targets.yearlyBooks)
                            .frame(height: 65)
                        Text("Anual")
                    }
                }
            }
        }
    }
}

struct MediumSizeView3_Previews: PreviewProvider {
    static var previews: some View {
        MediumSizeView3(entry: SimpleEntry(date: .now, data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
