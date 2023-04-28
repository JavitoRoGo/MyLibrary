//
//  SmallSizeView.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 26/12/22.
//

import SwiftUI
import WidgetKit

struct SmallSizeView: View {
    var entry: SimpleEntry
    
    var body: some View {
        if entry.data.bookTitle == "ninguno" {
            Text("Empieza a leer un libro para ver tu progreso.")
        } else {
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .stroke(entry.data.progress > 75 ? .green : entry.data.progress > 50 ? .yellow : entry.data.progress > 25 ? .orange : .red, lineWidth: 12).opacity(0.2)
                        .overlay {
                            Text("\(entry.data.progress)%")
                                .font(.title)
                        }
                    Circle()
                        .trim(from: 0, to: CGFloat(entry.data.progress) / 100)
                        .stroke(entry.data.progress > 75 ? .green : entry.data.progress > 50 ? .yellow : entry.data.progress > 25 ? .orange : .red,
                                style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                }
                .frame(width: 90, height: 90)
                Text(entry.data.bookTitle)
            }
        }
    }
}

struct SmallSizeView_Previews: PreviewProvider {
    static var previews: some View {
        SmallSizeView(entry: SimpleEntry(date: .now, data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
