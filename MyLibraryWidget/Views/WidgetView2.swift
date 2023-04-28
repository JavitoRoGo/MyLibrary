//
//  WidgetView2.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 27/12/22.
//

import SwiftUI
import WidgetKit

struct MyLibraryWidgetEntryView2 : View {
    @Environment(\.widgetFamily) var widgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch widgetFamily {
        case .systemMedium:
            MediumSizeView2(entry: entry)
        default:
            Text("No está implementado.")
        }
    }
}

struct MyLibraryWidgetEntryView2_Previews: PreviewProvider {
    static var previews: some View {
        MyLibraryWidgetEntryView2(entry: SimpleEntry(date: Date(), data: exampleData))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
