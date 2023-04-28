//
//  AnimateChartsHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/22.
//

import Foundation


// MARK: - Struct de datos y función, para RSBarGraph, NewBarGraph, y ChartsByDate, para asignar un bool a cada double del array y poder animar la gráfica de barras de SwiftCharts

// Nueva estructura de datos y array de datos para la gráfica animada de barras horizontales de las sesiones: RSBarGraph
    // La convertí usando genéricos para que sirva también para las cuatro de barras verticales de ChartsByDate
struct DataStructForAnimateGraph<T: Hashable, U: Hashable>: Identifiable {
    var id = UUID().uuidString
    var value: T
    var label: U
    var animate: Bool = false
}

func getValuesIntoDataArrayForAnimateGraph<T: Hashable, U: Hashable>(_ datas: [T], _ labels: [U]) -> [DataStructForAnimateGraph<T,U>] {
    var array: [DataStructForAnimateGraph<T,U>] = []
    for (index, data) in datas.enumerated() {
        array.append(.init(value: data, label: labels[index]))
    }
    return array
}


// Struct para gráfica animada de línea de las pág/día por libro
struct DataForLineChart {
    let name: String
    let value: [Double]
    var animate: [Bool]
}

// Struct para gráfica de puntos de max y min
struct DataForMaxMinChart {
    let book: String
    let maxValue: Int
    let minValue: Int
    var animate: Bool = false
}
