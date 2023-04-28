//
//  UserViewModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import Combine
import SwiftUI

final class UserViewModel: ObservableObject {
    // Propiedades Published
    @Published var user: User {
        didSet {
            Task {
                await saveToJson(userJson, user)
            }
            Task {
                // Actualizar datos para el widget
                if user.sessions.isEmpty {
                    if user.nowReading.isEmpty {
                        saveDataForWidget(sessions: [], read: loadReadData(), target: loadTargetData())
                    } else {
                        saveDataForWidget(book: user.nowReading[0], sessions: [], read: loadReadData(), target: loadTargetData())
                    }
                } else {
                    if user.nowReading.isEmpty {
                        saveDataForWidget(sessions: user.sessions, read: loadReadData(), target: loadTargetData())
                    } else {
                        saveDataForWidget(book: user.nowReading[0], sessions: user.sessions, read: loadReadData(), target: loadTargetData())
                    }
                }
            }
        }
    }
    @Published var myPlaces: [String] = loadMyPlaces() {
        didSet {
            Task { await saveToJson(myPlacesJson, myPlaces) }
            user.myPlaces = myPlaces
        }
    }
    @Published var password = ""
    @Published var validations: [Validation] = []
    @Published var isValid: Bool = false
    
    // Propiedades AppStorage
//    @AppStorage("storedUsername") var storedUsername = "" {
//        didSet {
//            user.username = storedUsername
//        }
//    }
    var storedPassword = keychain.get("storedPassword") ?? ""
    @AppStorage("isBiometricsAllowed") var isBiometricsAllowed = false
    @AppStorage("owners") var myOwners: [String] = []
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        user = Bundle.main.searchAndDecode(userJson) ?? User(id: UUID(), username: "", nickname: "", books: [Books](), ebooks: [EBooks](), readingDatas: [ReadingData](), nowReading: [NowReading](), nowWaiting: [NowReading](), sessions: [ReadingSession](), myPlaces: [String]())
        
        // Validations
        passwordPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validations, on: self)
            .store(in: &cancellableSet)
        
        // isValid
        passwordPublisher
            .receive(on: RunLoop.main)
            .map { validations in
                return validations.filter { validation in
                    return ValidationState.failure == validation.state
                }.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
    }
    
    private var passwordPublisher: AnyPublisher<[Validation], Never> {
        $password
            .removeDuplicates()
            .map { password in
                var validations: [Validation] = []
                validations.append(Validation(string: password, id: 0, field: .password, validationType: .isNotEmpty))
                validations.append(Validation(string: password, id: 1, field: .password, validationType: .minCharacters(min: 8)))
                validations.append(Validation(string: password, id: 2, field: .password, validationType: .hasSymbols))
                validations.append(Validation(string: password, id: 3, field: .password, validationType: .hasUppercasedLetters))
                validations.append(Validation(string: password, id: 4, field: .password, validationType: .hasNumbers))
                return validations
            }.eraseToAnyPublisher()
    }
    
    // MARK: - OBJETIVOS DE LECTURA:
    
    // Diario
    @AppStorage("dailyPagesTarget") var dailyPagesTarget: Int = 40
    @AppStorage("dailyTimeTarget") var dailyTimeTarget: Double = 1.0
    // Semanal
    @AppStorage("weeklyPagesTarget") var weeklyPagesTarget: Int = 250
    @AppStorage("weeklyTimeTarget") var weeklyTimeTarget: Double = 7.0
    // Mensual
    @AppStorage("monthlyPagesTarget") var monthlyPagesTarget: Int = 1000
    @AppStorage("monthlyTimeTarget") var monthlyBooksTarget: Int = 4
    // Anual
    @AppStorage("yearlyPagesTarget") var yearlyPagesTarget: Int = 8000
    @AppStorage("yearlyTimeTarget") var yearlyBooksTarget: Int = 40
    
    // Texto a mostrar según el objetivo
    func dailyTargetText(_ target: DWTarget) -> String {
        target == .pages ?
        "\(dailyPagesTarget) páginas" :
        "\(minPerDayDoubleToString(dailyTimeTarget))"
    }
    func weeklyTargetText(_ target: DWTarget) -> String {
        target == .pages ?
        "\(weeklyPagesTarget) páginas" :
        "\(minPerDayDoubleToString(weeklyTimeTarget))"
    }
    func monthlyTargetText(_ target: MYTarget) -> String {
        target == .pages ?
        "\(monthlyPagesTarget) páginas" :
        "\(monthlyBooksTarget) libros"
    }
    func yearlyTargetText(_ target: MYTarget) -> String {
        target == .pages ?
        "\(yearlyPagesTarget) páginas" :
        "\(yearlyBooksTarget) libros"
    }
    
    // Objetivo diario: páginas y tiempo leídos
    func readToday(_ target: DWTarget) -> (String, Int) {
        let todayComponents = Calendar.current.dateComponents([.day, .month, .year], from: Date())
        guard let mostRecentSession = ReadingSessionModel().readingSessionList.filter({ Calendar.current.dateComponents([.day, .month, .year], from: $0.date) == todayComponents }).first else { return  ("0",0) }
        switch target {
        case .pages:
            return (String(mostRecentSession.pages), mostRecentSession.pages)
        case .time:
            return (minPerDayDoubleToString(mostRecentSession.readingTimeInHours), Int(mostRecentSession.readingTimeInHours))
        }
    }
    
    // Objetivo semanal: páginas y tiempo leídos
    func readThisWeek(_ target: DWTarget) -> (String, Int) {
        let todayComponents = Calendar.current.dateComponents([.weekOfYear, .year], from: Date())
        let sessions = ReadingSessionModel().readingSessionList.filter({ Calendar.current.dateComponents([.weekOfYear, .year], from: $0.date) == todayComponents })
        if sessions.isEmpty {
            return ("0",0)
        } else {
            switch target {
            case .pages:
                let sum = sessions.reduce(0) { $0 + $1.pages }
                return (String(sum), sum)
            case .time:
                let sum = sessions.reduce(0) { $0 + $1.readingTimeInHours }
                return (minPerDayDoubleToString(sum), Int(sum))
            }
        }
    }
    
    // Objetivo mensual: libros y páginas leídas
    func readThisMonth(_ target: MYTarget) -> (String, Int) {
        let todayComponents = Calendar.current.dateComponents([.month, .year], from: Date())
        switch target {
        case .books:
            let booksRead = RDModel().readingDatas.filter({ Calendar.current.dateComponents([.month, .year], from: $0.finishDate) == todayComponents })
            if booksRead.isEmpty {
                return ("0",0)
            } else {
                return (String(booksRead.count), booksRead.count)
            }
        case .pages:
            let sessions = ReadingSessionModel().readingSessionList.filter({ Calendar.current.dateComponents([.month, .year], from: $0.date) == todayComponents })
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
            let booksRead = RDModel().readingDatas.filter({ Calendar.current.dateComponents([.year], from: $0.finishDate) == todayComponents })
            if booksRead.isEmpty {
                return ("0",0)
            } else {
                return (String(booksRead.count), booksRead.count)
            }
        case .pages:
            let sessions = ReadingSessionModel().readingSessionList.filter({ Calendar.current.dateComponents([.year], from: $0.date) == todayComponents })
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
            for session in user.sessions where session.pages >= dailyPagesTarget {
                count += 1
            }
        } else {
            for session in user.sessions where session.readingTimeInHours >= dailyTimeTarget {
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
        // Eliminar duplicados mediante extension .uniqued()
        years = years.uniqued()
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
                if pages >= weeklyPagesTarget {
                    count += 1
                }
            }
        } else {
            doubleSessionArray.forEach { sessionArray in
                let time = sessionArray.reduce(0) { $0 + $1.readingTimeInHours }
                if time >= weeklyTimeTarget {
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
        years = years.uniqued()
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
                if pages >= monthlyPagesTarget {
                    count += 1
                }
            }
        } else {
            // Obtener los grupos o array de libros por año y mes
            let books = RDModel().readingDatas
            var booksRead: [Int] = []
            years.forEach { year in
                for month in 1...12 {
                    let monthBooks = books.filter {
                        Calendar.current.dateComponents([.month, .year], from: $0.finishDate) == DateComponents(year: year, month: month)
                    }.count
                    booksRead.append(monthBooks)
                }
            }
            for read in booksRead where read >= monthlyBooksTarget {
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
        years = years.uniqued()
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
                if pages >= yearlyPagesTarget {
                    count += 1
                }
            }
        } else {
            let books = RDModel().readingDatas
            var booksRead: [Int] = []
            years.forEach { year in
                let yearBooks = books.filter {
                    Calendar.current.component(.year, from: $0.finishDate) == year
                }.count
                booksRead.append(yearBooks)
            }
            for read in booksRead where read >= yearlyBooksTarget {
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
            dailyPages: dailyPagesTarget, dailyTime: Int(dailyTimeTarget),
            weeklyPages: weeklyPagesTarget, weeklyTime: Int(weeklyTimeTarget),
            monthlyPages: monthlyPagesTarget, monthlyBooks: monthlyBooksTarget,
            yearlyPages: yearlyPagesTarget, yearlyBooks: yearlyBooksTarget
        )
    }
}
