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


let exampleCurrent = TargetForWidget(dailyPages: 20, dailyTime: 1, weeklyPages: 100, weeklyTime: 5, monthlyPages: 1000, monthlyBooks: 2, yearlyPages: 5500, yearlyBooks: 32)
let exampleTarget = TargetForWidget(dailyPages: 40, dailyTime: 2, weeklyPages: 250, weeklyTime: 7, monthlyPages: 1200, monthlyBooks: 4, yearlyPages: 8000, yearlyBooks: 40)
let exampleData = DataForWidget(bookTitle: "Leyendo libro", progress: 55, remaining: 69, sessions: [ReadingSession.example], read: exampleCurrent, targets: exampleTarget)
