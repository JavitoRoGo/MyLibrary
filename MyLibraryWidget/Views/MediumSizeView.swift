//
//  MediumSizeView.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 26/12/22.
//

import SwiftUI
import WidgetKit

struct MediumSizeView: View {
    var entry: SimpleEntry
	
	var uiimage: UIImage {
		if let image = getCoverImage(from: imageCoverName(from: entry.data.bookTitle)) {
			image
		} else {
			UIImage(systemName: "questionmark")!
		}
	}
    
    var body: some View {
        if entry.data.bookTitle == "ninguno" {
            Text("Empieza a leer un libro para ver tu progreso.")
        } else {
            HStack(spacing: 50) {
                Image(uiImage: uiimage)
                    .resizable()
                    .frame(width: 120, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.primary, lineWidth: 4)
                    }
                VStack(alignment: .leading, spacing: 15) {
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
                    .frame(width: 85, height: 85)
                    VStack(alignment: .leading, spacing: 0) {
                        Text(entry.data.bookTitle)
                        Text("Te faltan \(entry.data.remaining) pág")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct MediumSizeView_Previews: PreviewProvider {
    static var previews: some View {
        MediumSizeView(entry: SimpleEntry(date: .now, data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
