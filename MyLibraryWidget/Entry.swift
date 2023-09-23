//
//  Entry.swift
//  MyLibraryWidgetExtension
//
//  Created by Javier Rodríguez Gómez on 25/12/22.
//

import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date // este siempre tiene que estar para conformar a TimelineEntry
    let data: DataForWidget
}

// Estructura de datos que almacenar en AppGroup para usar en el widget
struct DataForWidget: Codable {
    let bookTitle: String
    let progress: Int
    let remaining: Int
    let sessions: [ReadingSession]
    let read: TargetForWidget
    let targets: TargetForWidget
}
struct TargetForWidget: Codable {
    let dailyPages: Int
    let dailyTime: Int
    let weeklyPages: Int
    let weeklyTime: Int
    let monthlyPages: Int
    let monthlyBooks: Int
    let yearlyPages: Int
    let yearlyBooks: Int
}
