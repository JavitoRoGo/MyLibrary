//
//  MediumSizeView2.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 27/12/22.
//

import Charts
import SwiftUI
import WidgetKit

struct MediumSizeView2: View {
    var entry: SimpleEntry
    
    var body: some View {
        if entry.data.sessions.isEmpty {
            Text("Empieza a leer un libro y registra tus sesiones de lectura.")
                .font(.title3)
                .padding(.horizontal)
        } else {
            VStack(spacing: 5) {
                Text("Lectura semanal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Chart(entry.data.sessions) { session in
                    BarMark(
                        x: .value("Fecha", session.date, unit: .weekday),
                        y: .value("Páginas", session.pages)
                    )
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.weekday())
                    }
                }
            }
            .padding(8)
        }
    }
}

struct MediumSizeView2_Previews: PreviewProvider {
    static var previews: some View {
        MediumSizeView2(entry: SimpleEntry(date: .now, data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
