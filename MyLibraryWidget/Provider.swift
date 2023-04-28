//
//  Provider.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 25/12/22.
//

import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    let data: DataForWidget = getDataForWidget()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), data: exampleData)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), data: exampleData)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entry: [SimpleEntry] = []
        entry.append(SimpleEntry(date: .now, data: data))
        let timeline = Timeline(entries: entry, policy: .atEnd)
        completion(timeline)
    }
}
