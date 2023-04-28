//
//  RDModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

final class RDModel: ObservableObject {
    @Published var readingDatas: [ReadingData] {
        didSet {
            Task { await saveToJson(readingDataJson, readingDatas) }
            UserViewModel().user.readingDatas = readingDatas
        }
    }
    
    init() {
        readingDatas = Bundle.main.searchAndDecode(readingDataJson) ?? []
    }
    
    func add(_ newRD: ReadingData) {
        readingDatas.append(newRD)
    }
    
    func numPerStar(_ stars: Int) -> Int {
        readingDatas.filter { $0.rating == stars }.count
    }
    
    func numPerYear(_ year: Year, filterBy: FilterByRating) -> Int {
        rdataPerYear(year, filterBy: filterBy).count
    }
    
    func rdataPerYear(_ year: Year, filterBy: FilterByRating) -> [ReadingData] {
        if filterBy != .all {
            return readingDatas.filter { $0.finishedInYear == year }.filter { $0.rating == filterBy.rawValue }.reversed()
        } else {
            return readingDatas.filter { $0.finishedInYear == year }.reversed()
        }
    }
    
    var allBookComments: [String: String] {
        var dict: [String: String] = [:]
        for readingData in readingDatas where readingData.comment != nil {
            dict[readingData.bookTitle] = readingData.comment
        }
        return dict
    }
    
    var meanMinPerPag: Double {
        let sum = readingDatas.reduce(0) { $0 + minPerPagInMinutes($1.minPerPag) }
        let mean = sum / Double(readingDatas.count)
        return mean
    }
    var meanMinPerDay: Double {
        let sum = readingDatas.reduce(0) { $0 + minPerDayInHours($1.minPerDay) }
        let mean = sum / Double(readingDatas.count)
        return mean
    }
    var meanPagPerDay: Double {
        let sum = readingDatas.reduce(0) { $0 + $1.pagPerDay }
        let mean = sum / Double(readingDatas.count)
        return mean
    }
    var meanOver50: Double {
        let sum = readingDatas.reduce(0) { $0 + $1.percentOver50 }
        let mean = sum / Double(readingDatas.count)
        return mean
    }
    
    // Datos para la gráfica estadística de anillo
    func datas(tag: Int) -> ([String], [Int]) {
        var labelArray: [String] = []
        var datasArray: [Int] = []
        switch tag {
        case 1:
            for year in Year.allCases.reversed() {
                var pages = 0
                for book in rdataPerYear(year, filterBy: .all) {
                    pages += book.pages
                }
                datasArray.append(pages)
                labelArray.append(String(year.rawValue))
            }
            return (labelArray, datasArray)
        case 2:
            for year in Year.allCases.reversed() {
                var ppday = 0
                let books = rdataPerYear(year, filterBy: .all)
                for book in books {
                    ppday += Int(book.pagPerDay)
                }
                let mean = (books.count == 0 ? 0 : ppday / books.count)
                datasArray.append(mean)
                labelArray.append(String(year.rawValue))
            }
            return (labelArray, datasArray)
        case 3:
            for formatt in Formatt.allCases {
                let books = readingDatas.filter { $0.formatt == formatt }.count
                datasArray.append(books)
                labelArray.append(formatt.rawValue)
            }
            return (labelArray, datasArray)
        case 4:
            for rating in 1..<6 {
                let books = readingDatas.filter { $0.rating == rating }.count
                datasArray.append(books)
            }
            return (labelArray, datasArray)
        default:
            for year in Year.allCases.reversed() {
                var books = 0
                books += numPerYear(year, filterBy: .all)
                datasArray.append(books)
                labelArray.append(String(year.rawValue))
            }
            return (labelArray, datasArray)
        }
    }
    
    // Datos para la gráfica de línea y puntos
    func datas() -> ([Double], [Double]) {
        var values = [Double]()
        var means = [Double]()
        var books = 0.0
        readingDatas.forEach { book in
            values.append(book.pagPerDay)
            books += 1.0
            let mean = values.reduce(0, +) / books
            means.append(mean)
        }
        return (values, means)
    }
    
    func getColors() -> [Color] {
        var colors = [Color]()
        for _ in 0..<5 {
            let red = Double.random(in: 0...255)
            let green = Double.random(in: 0...255)
            let blue = Double.random(in: 0...255)
            let color = Color(red: red/255, green: green/255, blue: blue/255, opacity: 0.8)
            colors.append(color)
        }
        return colors
    }
    
    // Datos para la gráfica de barras de sesiones
    func datas(book: ReadingData) -> [Double] {
        var values: [Double] = []
        book.readingSessions.forEach {
            values.append(Double($0.pages))
        }
        return values
    }
    
    func getLabels(book: ReadingData) -> [String] {
        var labels: [String] = []
        for session in book.readingSessions {
            let calendar = Calendar.current
            let day = calendar.component(.day, from: session.date)
            let month = calendar.component(.month, from: session.date)
            let text = "\(day)/\(month)"
            labels.append(text)
        }
        return labels
    }
    
    // Obtener el máximo y mínimo de cada sesión por libro, para la gráfica de puntos
    
    func getMaxMinPerBook() -> [DataForMaxMinChart] {
        var array: [DataForMaxMinChart] = []
        readingDatas.forEach { book in
            var pages = [Int]()
            book.readingSessions.forEach { session in
                pages.append(session.pages)
            }
            let max = pages.max() ?? 0
            let min = pages.min() ?? 0
            array.append(.init(book: book.bookTitle, maxValue: max, minValue: min))
        }
        return array
    }
    
    // Listado de ubicaciones
    
    var rdlocations: [RDLocation] {
        readingDatas.compactMap { $0.location }
    }
}


// MARK: - Funciones varias para obtener los valores para las estadísticas globales por formato

extension RDModel {
    // Listado de libros según formato
    func getRDBooks(_ formatt: Formatt) -> [ReadingData] {
        readingDatas.filter { $0.formatt == formatt }
    }
    
    // Número de libros
    func calcRDBooks(_ formatt: Formatt) -> Int {
        getRDBooks(formatt).count
    }
    
    // Número de páginas total y promedio. Total global
    func calcRDPages(_ formatt: Formatt? = nil) -> (total: Int, mean: Int) {
        if let formatt {
            let total = getRDBooks(formatt).reduce(0) { $0 + $1.pages }
            let mean = total / calcRDBooks(formatt)
            return (total, mean)
        }
        let total = readingDatas.reduce(0) { $0 + $1.pages }
        let mean = total / readingDatas.count
        return (total, mean)
    }
    
    // Tiempo total y promedio. Total global
    func calcRDDuration(_ formatt: Formatt? = nil) -> (total: Double, mean: Double) {
        if let formatt {
            var total = 0.0
            let books = getRDBooks(formatt)
            books.forEach { book in
                total += book.readingSessions.reduce(0) { $0 + $1.readingTimeInHours }
            }
            let mean = total / Double(calcRDBooks(formatt))
            return (total, mean)
        }
        var total = 0.0
        readingDatas.forEach { book in
            total += book.readingSessions.reduce(0) { $0 + $1.readingTimeInHours }
        }
        let mean = total / Double(readingDatas.count)
        return (total, mean)
    }
    
    // Velocidad promedio. El global ya está calculado como meanMinPerPag
    func calcRDMinPerPag(_ formatt: Formatt) -> Double {
        let total = getRDBooks(formatt).reduce(0) { $0 + minPerPagInMinutes($1.minPerPag) }
        let mean = total / Double(calcRDBooks(formatt))
        return mean
    }
    
    // Dedicación promedio. El global ya está calculado como meanMinPerDay
    func calcRDMinPerDay(_ formatt: Formatt) -> Double {
        let total = getRDBooks(formatt).reduce(0) { $0 + minPerDayInHours($1.minPerDay) }
        let mean = total / Double(calcRDBooks(formatt))
        return mean
    }
    
    // pag/dia promedio. El global ya está calculado como meanPagPerDay
    func calcRDPagPerDay(_ formatt: Formatt) -> Int {
        let total = getRDBooks(formatt).reduce(0) { $0 + $1.pagPerDay }
        let mean = Int(total) / calcRDBooks(formatt)
        return mean
    }
    
    // Valoración promedio y global
    func meanRDRating(_ formatt: Formatt? = nil) -> Double {
        if let formatt {
            let sum = Double(getRDBooks(formatt).reduce(0) { $0 + $1.rating })
            let mean = sum / Double(calcRDBooks(formatt))
            return mean
        }
        let sum = Double(readingDatas.reduce(0) { $0 + $1.rating })
        let mean = sum / Double(readingDatas.count)
        return mean
    }
}
