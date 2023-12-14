//
//  TimelyTargetExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 26/8/23.
//

import Algorithms
import Foundation

// MARK: - OBJETIVOS DE LECTURA:

extension UserLogic {
	// Texto a mostrar según el objetivo
	func dailyTargetText(_ target: DWTarget) -> String {
		target == .pages ?
		"\(UserPreferences().dailyPagesTarget) páginas" :
		"\(UserPreferences().dailyTimeTarget.minPerDayDoubleToString)"
	}
	func weeklyTargetText(_ target: DWTarget) -> String {
		target == .pages ?
		"\(UserPreferences().weeklyPagesTarget) páginas" :
		"\(UserPreferences().weeklyTimeTarget.minPerDayDoubleToString)"
	}
	func monthlyTargetText(_ target: MYTarget) -> String {
		target == .pages ?
		"\(UserPreferences().monthlyPagesTarget) páginas" :
		"\(UserPreferences().monthlyBooksTarget) libros"
	}
	func yearlyTargetText(_ target: MYTarget) -> String {
		target == .pages ?
		"\(UserPreferences().yearlyPagesTarget) páginas" :
		"\(UserPreferences().yearlyBooksTarget) libros"
	}
	
	// Objetivo diario: páginas y tiempo leídos
	func readToday(_ target: DWTarget) -> (String, Int) {
		let todayComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
		guard let mostRecentSession = user.sessions.filter({ Calendar.current.dateComponents([.day, .month, .year], from: $0.date) == todayComponents }).first else { return  ("0",0) }
		switch target {
			case .pages:
				return (String(mostRecentSession.pages), mostRecentSession.pages)
			case .time:
				return (mostRecentSession.readingTimeInHours.minPerDayDoubleToString, Int(mostRecentSession.readingTimeInHours))
		}
	}
	
	// Objetivo semanal: páginas y tiempo leídos
	func readThisWeek(_ target: DWTarget) -> (String, Int) {
		let todayComponents = Calendar.current.dateComponents([.weekOfYear, .year], from: Date())
		let sessions = user.sessions.filter({ Calendar.current.dateComponents([.weekOfYear, .year], from: $0.date) == todayComponents })
		if sessions.isEmpty {
			return ("0",0)
		} else {
			switch target {
				case .pages:
					let sum = sessions.reduce(0) { $0 + $1.pages }
					return (String(sum), sum)
				case .time:
					let sum = sessions.reduce(0) { $0 + $1.readingTimeInHours }
					return (sum.minPerDayDoubleToString, Int(sum))
			}
		}
	}
	
	// Objetivo mensual: libros y páginas leídas
	func readThisMonth(_ target: MYTarget) -> (String, Int) {
		let todayComponents = Calendar.current.dateComponents([.month, .year], from: Date())
		switch target {
			case .books:
				let booksRead = user.readingDatas.filter({ Calendar.current.dateComponents([.month, .year], from: $0.finishDate) == todayComponents })
				if booksRead.isEmpty {
					return ("0",0)
				} else {
					return (String(booksRead.count), booksRead.count)
				}
			case .pages:
				let sessions = user.sessions.filter({ Calendar.current.dateComponents([.month, .year], from: $0.date) == todayComponents })
				if sessions.isEmpty {
					return ("0",0)
				} else {
					let sum = sessions.reduce(0) { $0 + $1.pages }
					return (String(sum), sum)
				}
		}
	}
	
	// Objetivo anual: libros y páginas leídas
	func readThisYear(_ target: MYTarget) -> (String, Int) {
		let todayComponents = Calendar.current.dateComponents([.year], from: Date())
		switch target {
			case .books:
				let booksRead = user.readingDatas.filter({ Calendar.current.dateComponents([.year], from: $0.finishDate) == todayComponents })
				if booksRead.isEmpty {
					return ("0",0)
				} else {
					return (String(booksRead.count), booksRead.count)
				}
			case .pages:
				let sessions = user.sessions.filter({ Calendar.current.dateComponents([.year], from: $0.date) == todayComponents })
				if sessions.isEmpty {
					return ("0",0)
				} else {
					let sum = sessions.reduce(0) { $0 + $1.pages }
					return (String(sum), sum)
				}
		}
	}
	
	// Cálculo del número de objetivos diarios conseguidos
	func numOfAchivedDailyTarget(_ target: DWTarget) -> Int {
		var count = 0
		if target == .pages {
			// Simplemente comparar cada sesión de forma individual
			for session in user.sessions where session.pages >= UserPreferences().dailyPagesTarget {
				count += 1
			}
		} else {
			for session in user.sessions where session.readingTimeInHours >= UserPreferences().dailyTimeTarget {
				count += 1
			}
		}
		return count
	}
	
	// Cálculo del número de objetivos semanales conseguidos
	func numOfAchivedWeeklyTarget(_ target: DWTarget) -> Int {
		let sessions = user.sessions
		var count = 0
		var doubleSessionArray: [[ReadingSession]] = [[]]
		// Obtener todos los años de las sesiones
		var years: [Int] = []
		sessions.forEach { session in
			let year = Calendar.current.component(.year, from: session.date)
			years.append(year)
		}
		// Eliminar duplicados
		years = years.uniqued().sorted()
		// Iterar sobre los años
		years.forEach { year in
			// Iterar en cada semana del año para crear un array de sesiones de cada año y semana
			for week in 1...52 {
				let weekArray = sessions.filter {
					Calendar.current.dateComponents([.weekOfYear, .year], from: $0.date) == DateComponents(year: year, weekOfYear: week)
				}
				doubleSessionArray.append(weekArray)
			}
		}
		// Iterar sobre el array para sumar las páginas de cada elemento (array de sesiones)
		if target == .pages {
			doubleSessionArray.forEach { sessionArray in
				let pages = sessionArray.reduce(0) { $0 + $1.pages }
				if pages >= UserPreferences().weeklyPagesTarget {
					count += 1
				}
			}
		} else {
			doubleSessionArray.forEach { sessionArray in
				let time = sessionArray.reduce(0) { $0 + $1.readingTimeInHours }
				if time >= UserPreferences().weeklyTimeTarget {
					count += 1
				}
			}
		}
		
		return count
	}
	
	// Cálculo del número de objetivos mensuales conseguidos
	func numOfAchivedMonthlyTarget(_ target: MYTarget) -> Int {
		let sessions = user.sessions
		var count = 0
		// Obtener los años
		var years: [Int] = []
		sessions.forEach { session in
			let year = Calendar.current.component(.year, from: session.date)
			years.append(year)
		}
		years = years.uniqued().sorted()
		// Comparar el total por mes con el objetivo
		if target == .pages {
			// Obtener los grupos o array de sesiones por año y mes
			var doubleSessionArray: [[ReadingSession]] = [[]]
			years.forEach { year in
				for month in 1...12 {
					let monthArray = sessions.filter {
						Calendar.current.dateComponents([.month, .year], from: $0.date) == DateComponents(year: year, month: month)
					}
					doubleSessionArray.append(monthArray)
				}
			}
			doubleSessionArray.forEach { sessionArray in
				let pages = sessionArray.reduce(0) { $0 + $1.pages }
				if pages >= UserPreferences().monthlyPagesTarget {
					count += 1
				}
			}
		} else {
			// Obtener los grupos o array de libros por año y mes
			let books = user.readingDatas
			var booksRead: [Int] = []
			years.forEach { year in
				for month in 1...12 {
					let monthBooks = books.filter {
						Calendar.current.dateComponents([.month, .year], from: $0.finishDate) == DateComponents(year: year, month: month)
					}.count
					booksRead.append(monthBooks)
				}
			}
			for read in booksRead where read >= UserPreferences().monthlyBooksTarget {
				count += 1
			}
		}
		
		return count
	}
	
	// Cálculo del número de objetivos anuales conseguidos
	func numOfAchivedYearlyTarget(_ target: MYTarget) -> Int {
		let sessions = user.sessions
		var count = 0
		var years: [Int] = []
		sessions.forEach { session in
			let year = Calendar.current.component(.year, from: session.date)
			years.append(year)
		}
		years = years.uniqued().sorted()
		if target == .pages {
			var doubleSessionArray: [[ReadingSession]] = [[]]
			years.forEach { year in
				let yearArray = sessions.filter {
					Calendar.current.component(.year, from: $0.date) == year
				}
				doubleSessionArray.append(yearArray)
			}
			doubleSessionArray.forEach { sessionArray in
				let pages = sessionArray.reduce(0) { $0 + $1.pages }
				if pages >= UserPreferences().yearlyPagesTarget {
					count += 1
				}
			}
		} else {
			let books = user.readingDatas
			var booksRead: [Int] = []
			years.forEach { year in
				let yearBooks = books.filter {
					Calendar.current.component(.year, from: $0.finishDate) == year
				}.count
				booksRead.append(yearBooks)
			}
			for read in booksRead where read >= UserPreferences().yearlyBooksTarget {
				count += 1
			}
		}
		
		return count
	}
	
	// Carga de datos para el widget de objetivos
	func loadReadData() -> TargetForWidget {
		return TargetForWidget(
			dailyPages: readToday(.pages).1, dailyTime: readToday(.time).1,
			weeklyPages: readThisWeek(.pages).1, weeklyTime: readThisWeek(.time).1,
			monthlyPages: readThisMonth(.pages).1, monthlyBooks: readThisMonth(.books).1,
			yearlyPages: readThisYear(.pages).1, yearlyBooks: readThisYear(.books).1
		)
	}
	func loadTargetData() -> TargetForWidget {
		return TargetForWidget(
			dailyPages: UserPreferences().dailyPagesTarget, dailyTime: Int(UserPreferences().dailyTimeTarget),
			weeklyPages: UserPreferences().weeklyPagesTarget, weeklyTime: Int(UserPreferences().weeklyTimeTarget),
			monthlyPages: UserPreferences().monthlyPagesTarget, monthlyBooks: UserPreferences().monthlyBooksTarget,
			yearlyPages: UserPreferences().yearlyPagesTarget, yearlyBooks: UserPreferences().yearlyBooksTarget
		)
	}
}
