//
//  StringExtensions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 7/9/23.
//

import Foundation

// Uso de expresiones regulares en la comprobación de contraseña

extension String {
	func hasSpecialCharacters() -> Bool {
		stringFulFillsRegex(regex: ".*[^A-Za-z0-9]+.*")
		// regex: .* lo que sea salvo salto de línea
		// regex: [^A-Za-z0-9]+ lo que sea salvo letras y números, al menos uno
	}
	
	func hasUppercasedCharacters() -> Bool {
		stringFulFillsRegex(regex: ".*[A-Z]+.*")
		// regex: [A-Z]+ mayúsculas, al menos una
	}
	
	func hasNumbers() -> Bool {
		stringFulFillsRegex(regex: ".*[0-9]+.*")
	}
	
	private func stringFulFillsRegex(regex: String) -> Bool {
		let texttest = NSPredicate(format: "SELF MATCHES %@", regex)
		guard texttest.evaluate(with: self) else {
			return false
		}
		return true
	}
}


// Comprobación de email

extension String {
	func isValidEmail() -> Bool {
		let format = "SELF MATCHES %@"
		let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: format, regex).evaluate(with: self)
	}
}


// Funciones para pasar datos de tiempo de tipo String a Double:
// las funciones son iguales, pero las mantengo porque el nombre ayuda a aclarar las unidades del resultado en Double

extension String {
	var minPerPagInMinutes: Double {
		var min = 0.0
		var sec = 0.0
		let array = self.compactMap {
			let str = String($0)
			return Double(str)
		}
		
		if array.count == 1 {
			if self.prefix(1) == "m" {
				min = array[0]
			} else {
				sec = array[0]
			}
		} else if array.count == 2 {
			if self.prefix(1) == "m" {
				min = array[0]
				sec = array[1]
			} else {
				sec = array[0] * 10 + array[1]
			}
		} else if array.count == 3 {
			min = array[0]
			sec = array[1] * 10 + array[2]
		}
		let total = min + (sec / 60)
		
		return total
	}
	
	var minPerDayInHours: Double {
		var hour = 0.0
		var min = 0.0
		let array = self.compactMap {
			let str = String($0)
			return Double(str)
		}
		
		if array.count == 1 {
			if self.prefix(1) == "h" {
				hour = array[0]
			} else {
				min = array[0]
			}
		} else if array.count == 2 {
			if self.prefix(1) == "h" {
				hour = array[0]
				min = array[1]
			} else {
				min = array[0] * 10 + array[1]
			}
		} else if array.count == 3 {
			hour = array[0]
			min = array[1] * 10 + array[2]
		}
		let total = hour + (min / 60)
		
		return total
	}
}
