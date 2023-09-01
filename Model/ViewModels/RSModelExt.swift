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
    
    func getSessions(tag: Int) -> [ReadingSession] {
		let firstSessionDate = user.sessions.first?.date ?? .now
		if tag == 0 {
			return user.sessions.filter({ $0.date > (firstSessionDate - 7.days) })
		} else if tag == 1 {
			return user.sessions.filter({ $0.date > (firstSessionDate - 30.days) })
		} else if tag == 2 {
			return user.sessions.filter({ $0.date > (firstSessionDate - 1.years) })
		}
		return user.sessions
    }
        
    // Datos para la gráfica global de todas las sesiones
    
    func graphData(tag: Int) -> [Double] {
        var datas = [Double]()
        let sessions = getSessions(tag: tag)
        if tag == 2 {
			let count = sessions.count
			var data12 = 0.0
			var data11 = 0.0
			var data10 = 0.0
			var data9 = 0.0
			var data8 = 0.0
			var data7 = 0.0
			var data6 = 0.0
			var data5 = 0.0
			var data4 = 0.0
			var data3 = 0.0
			var data2 = 0.0
			var data1 = 0.0
			
			switch count {
				case 336...370:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152...182].forEach { data7 += Double($0.pages) }
					sessions[183...212].forEach { data6 += Double($0.pages) }
					sessions[213...243].forEach { data5 += Double($0.pages) }
					sessions[244...273].forEach { data4 += Double($0.pages) }
					sessions[274...304].forEach { data3 += Double($0.pages) }
					sessions[305...334].forEach { data2 += Double($0.pages) }
					sessions[335..<count].forEach { data1 += Double($0.pages) }
				case 306...335:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152...182].forEach { data7 += Double($0.pages) }
					sessions[183...212].forEach { data6 += Double($0.pages) }
					sessions[213...243].forEach { data5 += Double($0.pages) }
					sessions[244...273].forEach { data4 += Double($0.pages) }
					sessions[274...304].forEach { data3 += Double($0.pages) }
					sessions[305..<count].forEach { data2 += Double($0.pages) }
				case 275...305:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152...182].forEach { data7 += Double($0.pages) }
					sessions[183...212].forEach { data6 += Double($0.pages) }
					sessions[213...243].forEach { data5 += Double($0.pages) }
					sessions[244...273].forEach { data4 += Double($0.pages) }
					sessions[274..<count].forEach { data3 += Double($0.pages) }
				case 245...274:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152...182].forEach { data7 += Double($0.pages) }
					sessions[183...212].forEach { data6 += Double($0.pages) }
					sessions[213...243].forEach { data5 += Double($0.pages) }
					sessions[244..<count].forEach { data4 += Double($0.pages) }
				case 214...244:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152...182].forEach { data7 += Double($0.pages) }
					sessions[183...212].forEach { data6 += Double($0.pages) }
					sessions[213..<count].forEach { data5 += Double($0.pages) }
				case 184...213:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152...182].forEach { data7 += Double($0.pages) }
					sessions[183..<count].forEach { data6 += Double($0.pages) }
				case 153...183:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122...151].forEach { data8 += Double($0.pages) }
					sessions[152..<count].forEach { data7 += Double($0.pages) }
				case 123...152:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91...121].forEach { data9 += Double($0.pages) }
					sessions[122..<count].forEach { data8 += Double($0.pages) }
				case 92...122:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61...90].forEach { data10 += Double($0.pages) }
					sessions[91..<count].forEach { data9 += Double($0.pages) }
				case 62...91:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30...60].forEach { data11 += Double($0.pages) }
					sessions[61..<count].forEach { data10 += Double($0.pages) }
				case 31...61:
					sessions[0...29].forEach { data12 += Double($0.pages) }
					sessions[30..<count].forEach { data11 += Double($0.pages) }
				case 1...30:
					sessions[0..<count].forEach { data11 += Double($0.pages) }
				default:
					break
			}
            
            datas = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12]
			return datas
        }
        if tag == 3 {
			var years = [Int]()
			sessions.forEach { session in
				let year = Calendar.current.component(.year, from: session.date)
				years.append(year)
			}
			let yearsSet = Set(years).sorted()
			
			yearsSet.forEach { year in
				var yearData = 0.0
				for session in sessions where Calendar.current.component(.year, from: session.date) == year {
					yearData += Double(session.pages)
				}
				datas.append(yearData)
			}
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
			for i in stride(from: 1, to: (sessions.count < 29 ? sessions.count : 29), by: 6) {
                var text = String(sessions[i].date.formatted(date: .numeric, time: .omitted).prefix(5))
                if text.last == "/" {
                    text.removeLast()
                }
                labels.insert(text, at: 0)
            }
        }
        if tag == 2 {
            for i in stride(from: 1, to: (sessions.count < 340 ? sessions.count : 340), by: 60) {
                let formatter = DateFormatter()
                formatter.timeStyle = .none
                formatter.dateStyle = .long
                formatter.locale = Locale(identifier: "en")
                let text = String(formatter.string(from: sessions[i].date).prefix(3)).lowercased()
                labels.insert(text, at: 0)
            }
        }
        if tag == 3 {
			var years = [Int]()
			sessions.forEach { session in
				let year = Calendar.current.component(.year, from: session.date)
				years.append(year)
			}
			let yearsSet = Set(years).sorted()
			yearsSet.forEach { year in
				labels.append(String(year))
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
    
    // Cálculo del total de páginas por semana, mes y año para las 4 gráficas animadas de ChartsByDate
    
    func calcTotalPagesPerWeekAndMonth(tag: Int) -> (days: [Date], pages: [Int]) {
		let sessions = getSessions(tag: tag).reversed()
        // Variables para almacenar los resultados
        var dayArray = [Date]()
        var pagesArray = [Int]()
        
        // Obtener los valores para los array
        sessions.forEach { session in
            dayArray.append(session.date)
            pagesArray.append(session.pages)
        }
		
		// Completar los arrays de resultados en caso que no haya datos suficientes para el mes o la semana
		if tag == 0 && sessions.count < 7 {
			for i in (sessions.count + 1)..<7 {
				// Uso de DateHelper para restar fechas y componentes, creados a partir de Int
				let previousDate = sessions.last!.date - i.days
				dayArray.insert(previousDate, at: 0)
				pagesArray.insert(0, at: 0)
			}
		} else if tag == 1 && sessions.count < 30 {
			for i in (sessions.count + 1)..<30 {
				let previousDate = sessions.last!.date - i.days
				dayArray.insert(previousDate, at: 0)
				pagesArray.insert(0, at: 0)
			}
		}
        
        return (dayArray, pagesArray)
    }
    
    func calcTotalPagesPerMonth() -> (months: [String], pages: [Int]) {
		let sessions = getSessions(tag: 2).reversed()
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
