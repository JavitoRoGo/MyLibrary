//
//  StatsModelExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 27/8/23.
//

import Foundation
import SwiftUI

// Funciones para las estadísticas por ubicación

extension UserViewModel {
	
	// Selección del color
	func numColor(_ num: Int) -> Color {
		if num >= 50 {
			return Color(UIColor(red: 145/255, green: 0/255, blue: 0/255, alpha: 1))
		} else if num >= 40 {
			return .red
		} else if num >= 30 {
			return .orange
		} else if num >= 20 {
			return .yellow
		} else if num >= 10 {
			return .green
		} else {
			return .secondary
		}
	}
	
	// Datos globales
	func globalPages<T: BooksProtocol>(_ array: [T]) -> (total: Int, mean: Int) {
		let total = array.reduce(0) { $0 + $1.pages }
		let mean = total / array.count
		return(total, mean)
	}
	
	func globalPrice<T: BooksProtocol>(_ array: [T]) -> (total: Double, mean: Double) {
		let total = array.reduce(0) { $0 + $1.price }
		let mean = total / Double(array.count)
		return (total, mean)
	}
	
	func globalThickness() -> (total: Double, mean: Double) {
		let total = activeBooks.reduce(0) { $0 + $1.thickness }
		let mean = total / Double(activeBooks.count)
		return(total, mean)
	}
	
	func globalWeight() -> (total: Int, mean: Int) {
		let total = activeBooks.reduce(0) { $0 + $1.weight }
		let mean = total / activeBooks.count
		return(total, mean)
	}
	
	// Datos por ubicación
	func pagesAtPlace(_ place: String) -> (total: Int, mean: Int) {
		if place == "all" {
			return globalPages(activeBooks)
		}
		
		let books = booksAtPlace(place)
		if !books.isEmpty {
			let total = books.reduce(0) { $0 + $1.pages }
			let mean = total / books.count
			return(total, mean)
		} else {
			return(0, 0)
		}
	}
	
	func priceAtPlace(_ place: String) -> (total: Double, mean: Double) {
		if place == "all" {
			return globalPrice(activeBooks)
		}
		
		let books = booksAtPlace(place)
		if !books.isEmpty {
			let total = books.reduce(0) { $0 + $1.price }
			let mean = total / Double(books.count)
			return(total, mean)
		} else {
			return(0, 0)
		}
	}
	
	func thicknessAtPlace(_ place: String) -> (total: Double, mean: Double) {
		if place == "all" {
			return globalThickness()
		}
		
		let books = booksAtPlace(place)
		if !books.isEmpty {
			let total = books.reduce(0) { $0 + $1.thickness }
			let mean = total / Double(books.count)
			return(total, mean)
		} else {
			return(0, 0)
		}
	}
	
	func weightAtPlace(_ place: String) -> (total: Int, mean: Int) {
		if place == "all" {
			return globalWeight()
		}
		
		let books = booksAtPlace(place)
		if !books.isEmpty {
			let total = books.reduce(0) { $0 + $1.weight }
			let mean = total / books.count
			return(total, mean)
		} else {
			return(0, 0)
		}
	}
	
	// Datos para la gráfica estadística
	func datas(tag: Int) -> [Double] {
		let myPlaces = user.myPlaces
		var array: [Double] = []
		switch tag {
			case 1:
				myPlaces.forEach { place in
					let num = Double(pagesAtPlace(place).total)
					array.append(num)
				}
				return array
			case 2:
				myPlaces.forEach { place in
					let num = priceAtPlace(place).total
					array.append(num)
				}
				return array
			case 3:
				myPlaces.forEach { place in
					let num = thicknessAtPlace(place).total
					array.append(num)
				}
				return array
			case 4:
				myPlaces.forEach { place in
					let num = Double(weightAtPlace(place).total)
					array.append(num)
				}
				return array
			default:
				myPlaces.forEach { place in
					let num = Double(numberOfBooksAtPlace(place))
					array.append(num)
				}
				return array
		}
	}
}


// Funciones para las otras estadísticas en SwiftCharts: por autor, editorial, encuadernación y propietario

extension UserViewModel {
	
	// Función para obtener el listado de autores, editoriales, encuadernaciones y propietarios
	func arrayOfBookLabelsByCategoryForPickerAndGraph(tag: Int) -> [String] {
		var arrayOfData = [String]()
		
		// Por autor:
		if tag == 0 {
			activeBooks.forEach { book in
				arrayOfData.append(book.author)
			}
		} // Por editorial:
		else if tag == 1 {
			activeBooks.forEach { book in
				arrayOfData.append(book.publisher)
			}
		} // Por encuadernación:
		else if tag == 2 {
			Cover.allCases.forEach { cover in
				arrayOfData.append(cover.rawValue)
			}
		} // Por propietario:
		else if tag == 3 {
			UserViewModel().myOwners.forEach { owner in
				arrayOfData.append(owner)
			}
		} // Por estado:
		else if tag == 4 {
			ReadingStatus.allCases.forEach { status in
				arrayOfData.append(status.rawValue)
			}
		}
		
		return arrayOfData.uniqued().sorted()
	}
	
	// Función para obtener el número de libros y resto de datos para estadísticas según el valor del picker
	func numOfBooksForOtherStats(tag: Int, text: String) -> Int {
		// Por autor:
		if tag == 0 {
			return activeBooks.filter{ $0.author == text }.count
		} // Por editorial:
		else if tag == 1 {
			return activeBooks.filter{ $0.publisher == text }.count
		} // Por encuadernación:
		else if tag == 2 {
			guard let cover = Cover.init(rawValue: text) else { return 0 }
			return activeBooks.filter{ $0.coverType == cover }.count
		} // Por propietario:
		else if tag == 3 {
			return numberOfBooksByOwner(text)
		} // Por estado:
		else if tag == 4 {
			guard let status = ReadingStatus.init(rawValue: text) else { return 0 }
			return activeBooks.filter{ $0.status == status }.count
		}
		return 0
	}
	
	func numOfPagesForOtherStats(tag: Int, text: String) -> (total: Int, mean: Int) {
		// Por autor:
		if tag == 0 {
			let books = activeBooks.filter{ $0.author == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.pages }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por editorial:
		else if tag == 1 {
			let books = activeBooks.filter{ $0.publisher == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.pages }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por encuadernación:
		else if tag == 2 {
			guard let cover = Cover.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.coverType == cover }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.pages }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por propietario:
		else if tag == 3 {
			let books = booksByOwner(text)
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.pages }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por estado:
		else if tag == 4 {
			guard let status = ReadingStatus.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.status == status }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.pages }
				let mean = total / books.count
				return (total, mean)
			}
		}
		return(0, 0)
	}
	
	func priceForOtherStats(tag: Int, text: String) -> (total: Double, mean: Double) {
		// Por autor:
		if tag == 0 {
			let books = activeBooks.filter{ $0.author == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.price }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por editorial:
		else if tag == 1 {
			let books = activeBooks.filter{ $0.publisher == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.price }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por encuadernación:
		else if tag == 2 {
			guard let cover = Cover.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.coverType == cover }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.price }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por propietario:
		else if tag == 3 {
			let books = booksByOwner(text)
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.price }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por estado:
		else if tag == 4 {
			guard let status = ReadingStatus.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.status == status }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.price }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		}
		return(0.0, 0.0)
	}
	
	func thicknessForOtherStats(tag: Int, text: String) -> (total: Double, mean: Double) {
		// Por autor:
		if tag == 0 {
			let books = activeBooks.filter{ $0.author == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.thickness }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por editorial:
		else if tag == 1 {
			let books = activeBooks.filter{ $0.publisher == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.thickness }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por encuadernación:
		else if tag == 2 {
			guard let cover = Cover.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.coverType == cover }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.thickness }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por propietario:
		else if tag == 3 {
			let books = booksByOwner(text)
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.thickness }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		} // Por estado:
		else if tag == 4 {
			guard let status = ReadingStatus.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.status == status }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.thickness }
				let mean = total / Double(books.count)
				return (total, mean)
			}
		}
		return(0.0, 0.0)
	}
	
	func weightForOtherStats(tag: Int, text: String) -> (total: Int, mean: Int) {
		// Por autor:
		if tag == 0 {
			let books = activeBooks.filter{ $0.author == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.weight }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por editorial:
		else if tag == 1 {
			let books = activeBooks.filter{ $0.publisher == text }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.weight }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por encuadernación:
		else if tag == 2 {
			guard let cover = Cover.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.coverType == cover }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.weight }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por propietario:
		else if tag == 3 {
			let books = booksByOwner(text)
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.weight }
				let mean = total / books.count
				return (total, mean)
			}
		} // Por estado:
		else if tag == 4 {
			guard let status = ReadingStatus.init(rawValue: text) else { return (0,0) }
			let books = activeBooks.filter{ $0.status == status }
			if !books.isEmpty {
				let total = books.reduce(0) { $0 + $1.weight }
				let mean = total / books.count
				return (total, mean)
			}
		}
		return(0, 0)
	}
	
	// Función para obtener los datos a representar en las gráficas:
	func datasForOtherGraph(statName: Int, dataName: Int, text: String) -> Double {
		// statName viene del picker (autor, editorial...), dataName viene del menú (libros, páginas...), y text es el texto a buscar
		if statName == 0 {
			// Por autor:
			switch dataName {
				case 1:
					// Número de páginas
					return Double(numOfPagesForOtherStats(tag: statName, text: text).total)
				case 2:
					// Precio
					return priceForOtherStats(tag: statName, text: text).total
				case 3:
					// Grosor
					return thicknessForOtherStats(tag: statName, text: text).total
				case 4:
					// Peso
					return Double(weightForOtherStats(tag: statName, text: text).total)
				default:
					// Número de libros
					return Double(numOfBooksForOtherStats(tag: statName, text: text))
			}
		} else if statName == 1 {
			// Por editorial:
			switch dataName {
				case 1:
					// Número de páginas
					return Double(numOfPagesForOtherStats(tag: statName, text: text).total)
				case 2:
					// Precio
					return priceForOtherStats(tag: statName, text: text).total
				case 3:
					// Grosor
					return thicknessForOtherStats(tag: statName, text: text).total
				case 4:
					// Peso
					return Double(weightForOtherStats(tag: statName, text: text).total)
				default:
					// Número de libros
					return Double(numOfBooksForOtherStats(tag: statName, text: text))
			}
		} else if statName == 2 {
			// Por encuadernación:
			switch dataName {
				case 1:
					// Número de páginas
					return Double(numOfPagesForOtherStats(tag: statName, text: text).total)
				case 2:
					// Precio
					return priceForOtherStats(tag: statName, text: text).total
				case 3:
					// Grosor
					return thicknessForOtherStats(tag: statName, text: text).total
				case 4:
					// Peso
					return Double(weightForOtherStats(tag: statName, text: text).total)
				default:
					// Número de libros
					return Double(numOfBooksForOtherStats(tag: statName, text: text))
			}
		} else if statName == 3 {
			// Por propietario:
			switch dataName {
				case 1:
					// Número de páginas
					return Double(numOfPagesForOtherStats(tag: statName, text: text).total)
				case 2:
					// Precio
					return priceForOtherStats(tag: statName, text: text).total
				case 3:
					// Grosor
					return thicknessForOtherStats(tag: statName, text: text).total
				case 4:
					// Peso
					return Double(weightForOtherStats(tag: statName, text: text).total)
				default:
					// Número de libros
					return Double(numOfBooksForOtherStats(tag: statName, text: text))
			}
		} else if statName == 4 {
			// Por estado:
			switch dataName {
				case 1:
					// Número de páginas
					return Double(numOfPagesForOtherStats(tag: statName, text: text).total)
				case 2:
					// Precio
					return priceForOtherStats(tag: statName, text: text).total
				case 3:
					// Grosor
					return thicknessForOtherStats(tag: statName, text: text).total
				case 4:
					// Peso
					return Double(weightForOtherStats(tag: statName, text: text).total)
				default:
					// Número de libros
					return Double(numOfBooksForOtherStats(tag: statName, text: text))
			}
		}
		return 0.0
	}
}
