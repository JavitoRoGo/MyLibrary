//
//  WidgetView.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 25/12/22.
//

import SwiftUI
import WidgetKit

struct MyLibraryWidgetEntryView : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            SmallSizeView(entry: entry)
        case .systemMedium:
            MediumSizeView(entry: entry)
        default:
            Text("No está implementado.")
        }
    }
}

struct MyLibraryWidgetEntryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyLibraryWidgetEntryView(entry: SimpleEntry(date: Date(), data: exampleData))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                
        }
    }
}
