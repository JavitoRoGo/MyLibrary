//
//  DoubleExtensions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 7/9/23.
//

import Foundation

// Extension to convert double to string with K,M number values
extension Double {
	var stringFormat: String {
		if self >= 1100 && self < 999999 {
			return String(format: "%.1fK", self / 1000).replacingOccurrences(of: ".0", with: "")
		}
		if self > 999999 {
			return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
		}
		return String(format: "%.0f", self)
	}
}


// Funciones para pasar los datos de tiempo de tipo Double a String

extension Double {
	var minPerPagDoubleToString: String {
		var float = self.truncatingRemainder(dividingBy: 1)
		let min = Int(self - float)
		let seg = Int((float * 60).rounded())
		return "\(min)min \(seg)s"
	}
	
	var minPerDayDoubleToString: String {
		let float = self.truncatingRemainder(dividingBy: 1)
		let hour = Int(self - float)
		let min = Int((float * 60).rounded())
		return "\(hour)h \(min)min"
	}
}
