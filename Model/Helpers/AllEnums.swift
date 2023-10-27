//
//  AllEnums.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/4/22.
//

import SwiftUI

enum Cover: String, Codable, CaseIterable {
    case hardcover = "Cartoné"
    case pocket = "Rústica"
    case flapPocket = "Rústica con solapas"
}

// enum original para las ubicaciones. Sustituido por un array para poder modificarlo al gusto
//enum Place: String, Codable, CaseIterable, Identifiable {
//    case sold = "Vendidos", donated = "Donados"
//    case a1 = "A1", a2 = "A2", a3 = "A3", a4 = "A4", a5 = "A5"
//    case b1 = "B1", b2 = "B2", b3 = "B3", b4 = "B4", b5 = "B5"
//    case c1 = "C1", c2 = "C2", c3 = "C3", c4 = "C4", c5 = "C5", c6 = "C6", c7 = "C7", c8 = "C8"
//    case d1 = "D1", d2 = "D2", d3 = "D3", d4 = "D4", d5 = "D5", d6 = "D6", d7 = "D7", d8 = "D8"
//    case lp = "LP", pll = "PLL", tf = "TF", all = "Todos"
//    
//    var id: String { rawValue }
//}

// enum original para los propietarios. Sustituido por un array para poder modificarlo al gusto
//enum Owner: String, Codable, CaseIterable, Identifiable {
//    case javi = "Javi"
//    case aurora = "Aurora"
//    case lucas = "Lucas"
//    case yago = "Yago"
//    case comun = "Común"
//    
//    var id: String { rawValue }
//}

enum ReadingStatus: String, Codable, CaseIterable, Identifiable {
    case notRead = "No leído"
    case read = "Leído"
    case registered = "Registrado"
    case consulting = "Consultas"
//    case noStatus = "Desconocido"
    case reading = "Leyendo"
    case waiting = "En espera"
    
    var id: String { rawValue }
	
	var iconName: String {
		switch self {
			case .notRead:
				return "bookmark.slash"
			case .read:
				return "book"
			case .registered:
				return "paperclip"
			case .consulting:
				return "text.book.closed"
			case .reading:
				return "eyes"
			case .waiting:
				return "hourglass"
		}
	}
	
	var iconColor: Color {
		switch self {
			case .notRead:
				return .red
			case .read:
				return .green
			case .registered:
				return .blue
			case .consulting:
				return .brown
			case .reading:
				return .orange
			case .waiting:
				return .primary.opacity(0.8)
		}
	}
	
	var infoAlert: (title: String, message: String) {
		let title: String
		var message = "Pulsa para volver."
		switch self {
			case .registered:
				title = "Libro leído y con registro de lectura."
				message = "Pulsa para ver los detalles."
			case .notRead:
				title = "Libro sin leer o pendiente."
			case .read:
				title = "Libro leído pero sin registro de lectura."
			case .consulting:
				title = "Libro de consulta."
				//    case .noStatus:
				//        title = "Libro en estado desconocido."
			case .reading:
				title = "Libro en proceso de lectura."
				message = "Pulsa para ver los detalles."
			case .waiting:
				title = "Libro en lista de espera."
		}
		return (title, message)
	}
}

// enum original para el año en que se termina el libro. Sustituido por valores Int para automatizar su funcionamiento
//enum Year: Int, Codable, CaseIterable, Identifiable {
//    case year2019 = 2019
//    case year2020 = 2020
//    case year2021 = 2021
//    case year2022 = 2022
//    case year2023 = 2023
//    
//    var id: Int { rawValue }
//}

enum Formatt: String, Codable, CaseIterable {
    case paper = "Papel"
    case kindle = "Kindle"
}


// MARK: - FILTERING ENUMS

enum FilterByStatus: String, CaseIterable, Identifiable {
    case all = "Todos"
    case notRead = "No leído"
    case read = "Leído"
    case registered = "Registrado"
    case consulting = "Consultas"
//    case noStatus = "Desconocido"
    case reading = "Leyendo"
    case waiting = "En espera"
    
    var id: String { rawValue }
}

//enum FilterByOwner: String, CaseIterable, Identifiable {
//    case all = "Todos"
//    case javi = "Javi"
//    case aurora = "Aurora"
//    case lucas = "Lucas"
//    case yago = "Yago"
//    case comun = "Común"
//    
//    var id: String { rawValue }
//}

enum FilterByRating: Int, CaseIterable {
    case all = 0
    case star1
    case star2
    case star3
    case star4
    case star5
}


// MARK: - TARGET ENUMS
// Diario y semanal
enum DWTarget: String, CaseIterable {
    case pages = "Páginas"
    case time = "Tiempo"
}

// Mensual y anual
enum MYTarget: String, CaseIterable {
    case books = "Libros"
    case pages = "Páginas"
}

// MARK: - APPEARANCE SELECTION

enum UserAppearance: Int {
	case system = 0
	case light
	case dark
	
	var systemColorScheme: ColorScheme? {
		switch self {
			case .system: return nil
			case .light: return .light
			case .dark: return .dark
		}
	}
}
