//
//  WidgetDataHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 26/12/22.
//

import SwiftUI
import WidgetKit

// Función para grabar los datos en UserDefaults de AppGroup cada vez que haya un cambio
func saveDataForWidget(book: NowReading? = nil, sessions: [ReadingSession], read: TargetForWidget, target: TargetForWidget) {
    sharedGroup.removeObject(forKey: keyForWidgetData)
    let dataToSave = DataForWidget(
        bookTitle: book?.bookTitle ?? "ninguno",
        progress: book?.progress ?? 0,
        remaining: book?.remainingPages ?? 0,
        sessions: Array(sessions.prefix(7)),
        read: TargetForWidget(
            dailyPages: read.dailyPages, dailyTime: read.dailyTime,
            weeklyPages: read.weeklyPages, weeklyTime: read.weeklyTime,
            monthlyPages: read.monthlyPages, monthlyBooks: read.monthlyBooks,
            yearlyPages: read.yearlyPages, yearlyBooks: read.yearlyBooks
        ),
        targets: TargetForWidget(
            dailyPages: target.dailyPages, dailyTime: target.dailyTime,
            weeklyPages: target.weeklyPages, weeklyTime: target.weeklyTime,
            monthlyPages: target.monthlyPages, monthlyBooks: target.monthlyBooks,
            yearlyPages: target.yearlyPages, yearlyBooks: target.yearlyBooks
        )
    )
    if let jsonData = try? JSONEncoder().encode(dataToSave) {
        sharedGroup.set(jsonData, forKey: keyForWidgetData)
        print("Datos para widget guardados en UserDefaults")
        WidgetCenter.shared.reloadAllTimelines()
    }
}

// Función para leer los datos de UserDefaults de AppGroup para el widget
func getDataForWidget() -> DataForWidget {
    var finalData = DataForWidget(bookTitle: "ninguno", progress: 0, remaining: 0, sessions: [], read: TargetForWidget(dailyPages: 0, dailyTime: 0, weeklyPages: 0, weeklyTime: 0, monthlyPages: 0, monthlyBooks: 0, yearlyPages: 0, yearlyBooks: 0), targets: TargetForWidget(dailyPages: 0, dailyTime: 0, weeklyPages: 0, weeklyTime: 0, monthlyPages: 0, monthlyBooks: 0, yearlyPages: 0, yearlyBooks: 0))
    if let data = sharedGroup.data(forKey: keyForWidgetData),
       let decoded = try? JSONDecoder().decode(DataForWidget.self, from: data) {
        finalData = decoded
        print("Datos para widget cargados desde UserDefaults")
    }
    return finalData
}
