//
//  WidgetView3.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 19/1/23.
//

import SwiftUI
import WidgetKit

struct MyLibraryWidgetEntryView3 : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            MediumSizeView3(entry: entry)
        default:
            Text("No está implementado.")
        }
    }
}

struct MyLibraryWidgetEntryView3_Previews: PreviewProvider {
    static var previews: some View {
        MyLibraryWidgetEntryView3(entry: SimpleEntry(date: Date(), data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
