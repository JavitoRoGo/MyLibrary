//
//  RSModelExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 7/6/22.
//

import SwiftUI
import WidgetKit

// Extension for RSModel: handling with reading sessions

extension UserViewModel {
	
	// Recopilación de citas y comentarios de todas las sesiones
    var allQuotes: [Quote] {
        var array: [Quote] = []
        user.sessions.forEach { session in
            session.quotes?.forEach { quote in
                array.append(quote)
            }
        }
        return array
    }
    var allComments: [Quote] {
        user.sessions.compactMap { $0.comment }
    }
    
    // Datos previos
    var toDate: Date {
        user.sessions.first?.date ?? .now
    }
    
    func getFromDate(tag: Int) -> Date {
        var substractingInterval: Double {
            if tag == 0 {
                return 3600 * 24 * 6
            } else if tag == 1 {
                return 3600 * 24 * 29
            } else if tag == 2 {
                return 3600 * 24 * 364
            } else {
                return 1
            }
        }
        var fromDate: Date {
            if tag == 3 {
                return user.sessions.last?.date ?? .now
            }
            return toDate.addingTimeInterval(-substractingInterval)
        }
        return fromDate
    }
    
    func getSessions(tag: Int) -> [ReadingSession] {
        user.sessions.prefix(while: { $0.date >= getFromDate(tag: tag) })
    }
        
    // Datos para la gráfica global de todas las sesiones
    
    func graphData(tag: Int) -> [Double] {
        var datas = [Double]()
        let sessions = getSessions(tag: tag)
        if tag == 2 {
			let count = sessions.count
			// varios if en función del número de elementos (count)
			var data12 = 0.0
            sessions[0...29].forEach { data12 += Double($0.pages) }
            var data11 = 0.0
            sessions[30...60].forEach { data11 += Double($0.pages) }
            var data10 = 0.0
            sessions[61...90].forEach { data10 += Double($0.pages) }
            var data9 = 0.0
            sessions[91...121].forEach { data9 += Double($0.pages) }
            var data8 = 0.0
            sessions[122...151].forEach { data8 += Double($0.pages) }
            var data7 = 0.0
            sessions[152...182].forEach { data7 += Double($0.pages) }
            var data6 = 0.0
            sessions[183...212].forEach { data6 += Double($0.pages) }
            var data5 = 0.0
            sessions[213...243].forEach { data5 += Double($0.pages) }
            var data4 = 0.0
            sessions[244...273].forEach { data4 += Double($0.pages) }
            var data3 = 0.0
            sessions[274...304].forEach { data3 += Double($0.pages) }
            var data2 = 0.0
            sessions[305...334].forEach { data2 += Double($0.pages) }
            var data1 = 0.0
            sessions[335...364].forEach { data1 += Double($0.pages) }
            datas = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12]
			// usar map para eliminar los elementos de datas que sean 0
			return datas
        }
        if tag == 3 {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .short
            formatter.locale = Locale(identifier: "es")
            
            let year2019 = formatter.date(from: "31/12/2019")!
            let year2020 = formatter.date(from: "31/12/2020")!
            let year2021 = formatter.date(from: "31/12/2021")!
            let year2022 = formatter.date(from: "31/12/2022")!
            var datas2019 = 0.0
            var datas2020 = 0.0
            var datas2021 = 0.0
            var datas2022 = 0.0
            for element in sessions where element.date <= year2019 {
                datas2019 += Double(element.pages)
            }
            for element in sessions where (element.date <= year2020 && element.date > year2019) {
                datas2020 += Double(element.pages)
            }
            for element in sessions where (element.date <= year2021 && element.date > year2020) {
                datas2021 += Double(element.pages)
            }
            for element in sessions where (element.date <= year2022 && element.date > year2021) {
                datas2022 += Double(element.pages)
            }
            datas = [datas2019, datas2020, datas2021, datas2022]
            return datas
        }
        sessions.forEach { session in
            datas.insert(Double(session.pages), at: 0)
        }
        return datas
    }
    
    func getXLabels(tag: Int) -> [String] {
        var labels: [String] = []
        let sessions = getSessions(tag: tag)
        if tag == 0 {
            sessions.forEach { session in
                let text = String(session.date.formatted(date: .complete, time: .omitted).prefix(3).lowercased())
                labels.insert(text, at: 0)
            }
        }
        if tag == 1 {
            for i in stride(from: 1, to: 29, by: 6) {
                var text = String(sessions[i].date.formatted(date: .numeric, time: .omitted).prefix(5))
                if text.last == "/" {
                    text.removeLast()
                }
                labels.insert(text, at: 0)
            }
        }
        if tag == 2 {
            for i in stride(from: 1, to: 340, by: 60) {
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateStyle = .long
                formatter.locale = Locale(identifier: "en")
                let text = String(formatter.string(from: sessions[i].date).prefix(3)).lowercased()
                labels.insert(text, at: 0)
            }
        }
        if tag == 3 {
            for year in Year.allCases {
                labels.append(String(year.rawValue))
            }
        }
        return labels
    }
    
    // Datos para la tabla resumen
    
    func getReadingTime(tag: Int) -> String {
        let sessions = getSessions(tag: tag)
        let time = sessions.reduce(0) { $0 + $1.readingTimeInHours }
        return minPerDayDoubleToString(time)
    }
    
    func getMinPerPag(tag: Int) -> String {
        let sessions = getSessions(tag: tag)
        let sum = sessions.reduce(0) { $0 + $1.minPerPagSessionInMinutes }
        let mean = sum / Double(sessions.count)
        return minPerPagDoubleToString(mean)
    }
    
    func getMinPerDay(tag: Int) -> String {
        let sessions = getSessions(tag: tag)
        let sum = sessions.reduce(0) { $0 + $1.readingTimeInHours }
        let mean = sum / Double(sessions.count)
        return minPerDayDoubleToString(mean)
    }
    
    func getPagPerDay(tag: Int) -> Double {
        let sessions = getSessions(tag: tag)
        let sum = Double(sessions.reduce(0) { $0 + $1.pages })
        let mean = sum / Double(sessions.count)
        return mean
    }
    
    // Datos para la gráfica de barras global de todas las sesiones
    
    func datas(sessions: [ReadingSession]) -> [Double] {
        var values: [Double] = []
        sessions.forEach {
            values.append(Double($0.pages))
        }
        return values
    }
    
    func getXLabels(sessions: [ReadingSession]) -> [String] {
        var labels: [String] = []
        sessions.forEach { session in
            let calendar = Calendar.current
            let day = calendar.component(.day, from: session.date)
            let month = calendar.component(.month, from: session.date)
            let text = "\(day)/\(month)"
            labels.append(text)
        }
        return labels
    }
    
    // Datos para la gráfica de barras de sesiones por libro
    func datas(book: NowReading) -> [Double] {
        var values: [Double] = []
        book.sessions.forEach {
            values.append(Double($0.pages))
        }
        return values
    }
    
    func getXLabels(book: NowReading) -> [String] {
        var labels: [String] = []
        book.sessions.forEach { session in
            let calendar = Calendar.current
            let day = calendar.component(.day, from: session.date)
            let month = calendar.component(.month, from: session.date)
            let text = "\(day)/\(month)"
            labels.append(text)
        }
        return labels
    }
}

// MARK: - Extensión para las gráficas animadas con Swift Charts

extension UserViewModel {
    
    // Funciones para la gráfica de barra de las sesiones con Swift Charts
    
    func getSessionsForBarMark(tag: Int) -> [ReadingSession] {
        var sessions = [ReadingSession]()
        if tag == 0 {
			if user.sessions.count <= 7 {
				return user.sessions.reversed()
			}
            for i in 0...6 {
                sessions.insert(user.sessions[i], at: 0)
            }
        } else if tag == 1 {
			if user.sessions.count <= 30 {
				return user.sessions.reversed()
			}
            for i in 0...29 {
                sessions.insert(user.sessions[i], at: 0)
            }
        } else if tag == 2 {
			if user.sessions.count <= 365 {
				return user.sessions.reversed()
			}
            for i in 0...364 {
                sessions.insert(user.sessions[i], at: 0)
            }
        } else if tag == 3 {
            return user.sessions.reversed()
        }
        return sessions
    }
    
    // Cálculo del total de páginas por semana, mes y año para las 4 gráficas animadas de ChartsByDate
    
    func calcTotalPagesPerWeekAndMonth(tag: Int) -> (days: [Date], pages: [Int]) {
        let sessions = getSessionsForBarMark(tag: tag)
        // Variables para almacenar los resultados
        var dayArray = [Date]()
        var pagesArray = [Int]()
        
        // Obtener los valores para los array
        sessions.forEach { session in
            dayArray.append(session.date)
            pagesArray.append(session.pages)
        }
        
        return (dayArray, pagesArray)
    }
    
    func calcTotalPagesPerMonth() -> (months: [String], pages: [Int]) {
        let sessions = getSessionsForBarMark(tag: 2)
        let calendar = Calendar.current
        // Variables para almacenar los resultados
        var monthArray = [Int]()
        var pagesArray = [Int]()
        
        // Obtener el mes de la última sesión del array (la más reciente). Y el año, para no sumar ese mes del año anterior
        let lastMonth = calendar.component(.month, from: sessions.last?.date ?? .now)
        let lastYear = calendar.component(.year, from: sessions.last?.date ?? .now)
        // Obtener array con los meses
        var monthToAdd = lastMonth
        repeat {
            monthArray.insert(monthToAdd, at: 0)
            monthToAdd -= 1
            if monthToAdd < 1 {
                monthToAdd = 12
            }
        } while monthToAdd != lastMonth
        
        // Obtener las sesiones por mes y sumar las páginas para esas sesiones
        monthArray.forEach { month in
            var totalPagesPerMonth = 0
            var monthSessions = [ReadingSession]()
            if month != lastMonth {
                monthSessions = sessions.filter{ calendar.component(.month, from: $0.date) == month }
            } else {
                monthSessions = sessions.filter{
                    calendar.component(.month, from: $0.date) == month &&
                    calendar.component(.year, from: $0.date) == lastYear
                }
            }
            monthSessions.forEach { session in
                totalPagesPerMonth += session.pages
            }
            pagesArray.append(totalPagesPerMonth)
        }
        
        // Pasar el array numérico de meses a cadenas
        let monthString = ["ene","feb","mar","abr","may","jun","jul","ago","sep","oct","nov","dic"]
        let finalMonthArray = monthArray.map {
            monthString[$0-1]
        }
        
        return (finalMonthArray, pagesArray)
    }
    
    func calcTotalPagesPerYear() -> (years: [String], pages: [Int]) {
        let sessions = user.sessions.reversed()
        let calendar = Calendar.current
        // Variables para almacenar los resultados
        var yearArray = [Int]()
        var pagesArray = [Int]()
        
        // Obtener el año de la primera sesión del array (la más vieja), y de la última (más reciente)
        let lastYear = calendar.component(.year, from: sessions.last?.date ?? .now)
        let firstYear = calendar.component(.year, from: sessions.first?.date ?? .now)
        // Obtener array con los años
        var yearToAdd = firstYear
        repeat {
            yearArray.append(yearToAdd)
            yearToAdd += 1
        } while yearToAdd <= lastYear
        let finalYearArray = yearArray.map{ "\($0)" }
        
        // Obtener las sesiones por año y sumar las páginas para esas sesiones
        yearArray.forEach { year in
            var totalPagesPerYear = 0
            let yearSessions = sessions.filter{ calendar.component(.year, from: $0.date) == year }
            yearSessions.forEach { session in
                totalPagesPerYear += session.pages
            }
            // Asignar la suma de páginas al array
            pagesArray.append(totalPagesPerYear)
        }
        
        return (finalYearArray, pagesArray)
    }
}
