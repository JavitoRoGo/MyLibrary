//
//  Extensions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 28/1/23.
//

import SwiftUI

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


// Extension para usar UserDefaults con array de string

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data) else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return result
    }
}


// Extension para eliminar elementos duplicados en Array

extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return self.filter { seen.insert($0).inserted }
    }
}


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
