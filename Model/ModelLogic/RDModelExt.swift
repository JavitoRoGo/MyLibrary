//
//  RDModelExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

// Extension for RDModel: handling with ReadingData

extension UserLogic {
    
    func addNewReadingData(_ newRD: ReadingData) {
		user.readingDatas.append(newRD)
    }
    
    func numberOfReadingDataPerStar(_ stars: Int) -> Int {
		user.readingDatas.filter { $0.rating == stars }.count
    }
    
    func rdataPerYear(_ year: Int, filterBy: FilterByRating) -> [ReadingData] {
        if filterBy != .all {
			return user.readingDatas.filter { $0.finishedInYear == year }.filter { $0.rating == filterBy.rawValue }.reversed()
        } else {
			return user.readingDatas.filter { $0.finishedInYear == year }.reversed()
        }
    }
    
	func numberOfReadingDataPerYear(_ year: Int, filterBy: FilterByRating) -> Int {
		rdataPerYear(year, filterBy: filterBy).count
	}
	
	var allReadingDataComments: [String: (String, Int)] {
        var dict: [String: (String, Int)] = [:]
		for readingData in user.readingDatas where readingData.comment != nil {
			dict[readingData.bookTitle] = (readingData.comment!, readingData.rating)
        }
        return dict
    }
	
	// MARK: - Valores y funciones para las estadísticas y gráficas
    
	// Datos de medias globales
	
    var meanMinPerPag: Double {
		if user.readingDatas.isEmpty {
			return 1.0
		}
		let sum = user.readingDatas.reduce(0) { $0 + $1.minPerPag.minPerPagInMinutes }
		let mean = sum / Double(user.readingDatas.count)
        return mean
    }
    var meanMinPerDay: Double {
		if user.readingDatas.isEmpty {
			return 1.0
		}
		let sum = user.readingDatas.reduce(0) { $0 + $1.minPerDay.minPerDayInHours }
		let mean = sum / Double(user.readingDatas.count)
        return mean
    }
    var meanPagPerDay: Double {
		if user.readingDatas.isEmpty {
			return 1.0
		}
		let sum = user.readingDatas.reduce(0) { $0 + $1.pagPerDay }
		let mean = sum / Double(user.readingDatas.count)
        return mean
    }
    var meanOver50: Double {
		if user.readingDatas.isEmpty {
			return 1.0
		}
		let sum = user.readingDatas.reduce(0) { $0 + $1.percentOver50 }
		let mean = sum / Double(user.readingDatas.count)
        return mean
    }
    
    // Datos para la gráfica estadística de anillo
    func datas(tag: Int) -> [SectorChartData] {
        var datasArray: [SectorChartData] = []
		let colors = getColors()
		switch tag {
			case 1:
				for (index, year) in user.bookFinishingYears.enumerated() {
					var pages = 0
					for book in rdataPerYear(year, filterBy: .all) {
						pages += book.pages
					}
					datasArray.append(.init(label: String(year), data: pages, color: colors[index]))
				}
				return datasArray
			case 2:
				for (index, year) in user.bookFinishingYears.enumerated() {
					var ppday = 0
					let books = rdataPerYear(year, filterBy: .all)
					for book in books {
						ppday += Int(book.pagPerDay)
					}
					let mean = (books.count == 0 ? 0 : ppday / books.count)
					datasArray.append(.init(label: String(year), data: mean, color: colors[index]))
				}
				return datasArray
			case 3:
				for (index, formatt) in Formatt.allCases.enumerated() {
					let books = numberOfReadingDataPerFormatt(formatt)
					datasArray.append(.init(label: formatt.rawValue, data: books, color: colors[index]))
				}
				return datasArray
			case 4:
				for (index, rating) in (1..<6).enumerated() {
					let books = user.readingDatas.filter { $0.rating == rating }.count
					datasArray.append(.init(label: "\(rating) \(rating == 1 ? "estrella" : "estrellas")", data: books, color: colors[index]))
				}
				return datasArray
			default:
				for (index, year) in user.bookFinishingYears.enumerated() {
					var books = 0
					books += numberOfReadingDataPerYear(year, filterBy: .all)
					datasArray.append(.init(label: String(year), data: books, color: colors[index]))
				}
				return datasArray
		}
    }
    
	// Colores aleatorios para la gráfica de anillo
	func getColors() -> [Color] {
		let num = max(user.bookFinishingYears.count, 5)
		var colors = [Color]()
		for _ in 0..<num {
			let red = Double.random(in: 0...255)
			let green = Double.random(in: 0...255)
			let blue = Double.random(in: 0...255)
			let color = Color(red: red/255, green: green/255, blue: blue/255, opacity: 0.8)
			colors.append(color)
		}
		return colors
	}
	
	// Datos para la gráfica de línea y puntos
    func datasForPagPerDay() -> ([Double], [Double]) {
        var values = [Double]()
        var means = [Double]()
        var books = 0.0
		user.readingDatas.forEach { book in
            values.append(book.pagPerDay)
            books += 1.0
            let mean = values.reduce(0, +) / books
            means.append(mean)
        }
        return (values, means)
    }
    
	// Datos para la gráfica de barras de sesiones
    func datasForSessionsBarGraph(book: ReadingData) -> [Double] {
        var values: [Double] = []
        book.readingSessions.forEach {
            values.append(Double($0.pages))
        }
        return values
    }
    
    func getLabelsForSessionsBarGraph(book: ReadingData) -> [String] {
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
    
    func getMaxAndMinPagesPerBook() -> [DataForMaxMinChart] {
        var array: [DataForMaxMinChart] = []
		user.readingDatas.forEach { book in
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
		user.readingDatas.compactMap { $0.location }
    }
}


// MARK: - Funciones varias para obtener los valores para las estadísticas globales por formato

extension UserLogic {
    // Listado de registros según formato
    func getReadingDataPerFormatt(_ formatt: Formatt) -> [ReadingData] {
		user.readingDatas.filter { $0.formatt == formatt }
    }
    
    // Número de registros según formato
    func numberOfReadingDataPerFormatt(_ formatt: Formatt) -> Int {
        getReadingDataPerFormatt(formatt).count
    }
    
    // Número de páginas total y promedio. Total global y por formato
    func calcRDPagesPerFormatt(_ formatt: Formatt? = nil) -> (total: Int, mean: Int) {
        if let formatt {
            let total = getReadingDataPerFormatt(formatt).reduce(0) { $0 + $1.pages }
            let mean = total / numberOfReadingDataPerFormatt(formatt)
            return (total, mean)
        }
		let total = user.readingDatas.reduce(0) { $0 + $1.pages }
		let mean = total / user.readingDatas.count
        return (total, mean)
    }
    
    // Tiempo total y promedio. Total global y por formato
    func calcRDDurationPerFormatt(_ formatt: Formatt? = nil) -> (total: Double, mean: Double) {
        if let formatt {
            var total = 0.0
            let books = getReadingDataPerFormatt(formatt)
            books.forEach { book in
                total += book.readingSessions.reduce(0) { $0 + $1.readingTimeInHours }
            }
            let mean = total / Double(numberOfReadingDataPerFormatt(formatt))
            return (total, mean)
        }
        var total = 0.0
		user.readingDatas.forEach { book in
            total += book.readingSessions.reduce(0) { $0 + $1.readingTimeInHours }
        }
		let mean = total / Double(user.readingDatas.count)
        return (total, mean)
    }
    
    // Velocidad promedio por formato. El global ya está calculado como meanMinPerPag
    func calcRDMinPerPagPerFormatt(_ formatt: Formatt) -> Double {
		let total = getReadingDataPerFormatt(formatt).reduce(0) { $0 + $1.minPerPag.minPerPagInMinutes }
        let mean = total / Double(numberOfReadingDataPerFormatt(formatt))
        return mean
    }
    
    // Dedicación promedio por formato. El global ya está calculado como meanMinPerDay
    func calcRDMinPerDayPerFormatt(_ formatt: Formatt) -> Double {
		let total = getReadingDataPerFormatt(formatt).reduce(0) { $0 + $1.minPerDay.minPerDayInHours }
        let mean = total / Double(numberOfReadingDataPerFormatt(formatt))
        return mean
    }
    
    // pag/dia promedio por formato. El global ya está calculado como meanPagPerDay
    func calcRDPagPerDayPerFormatt(_ formatt: Formatt) -> Int {
        let total = getReadingDataPerFormatt(formatt).reduce(0) { $0 + $1.pagPerDay }
        let mean = Int(total) / numberOfReadingDataPerFormatt(formatt)
        return mean
    }
    
    // Valoración por formato promedio y global
    func meanRDRatingPerFormatt(_ formatt: Formatt? = nil) -> Double {
        if let formatt {
            let sum = Double(getReadingDataPerFormatt(formatt).reduce(0) { $0 + $1.rating })
            let mean = sum / Double(numberOfReadingDataPerFormatt(formatt))
            return mean
        }
		let sum = Double(user.readingDatas.reduce(0) { $0 + $1.rating })
		let mean = sum / Double(user.readingDatas.count)
        return mean
    }
}
