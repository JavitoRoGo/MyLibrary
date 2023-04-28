//
//  CheckingPasswordHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/1/23.
//

import SwiftUI

enum Field: String {
    case username = "usuario"
    case password = "contraseña"
}

enum ValidationState {
    case success
    case failure
}

enum ValidationType {
    case isNotEmpty
    case minCharacters(min: Int)
    case hasSymbols
    case hasUppercasedLetters
    case hasNumbers
    
    func fulfills(string: String) -> Bool {
        switch self {
        case .isNotEmpty:
            return !string.isEmpty
        case .minCharacters(let min):
            return string.count > min
        case .hasSymbols:
            return string.hasSpecialCharacters()
        case .hasUppercasedLetters:
            return string.hasUppercasedCharacters()
        case .hasNumbers:
            return string.hasNumbers()
        }
    }
    
    func message(fieldName: String) -> String {
        switch self {
        case .isNotEmpty:
            return "El valor \(fieldName) no puede estar vacío."
        case .minCharacters(let min):
            return "El valor \(fieldName) debe tener más de \(min) caracteres."
        case .hasSymbols:
            return "El valor \(fieldName) debe tener algún símbolo."
        case .hasUppercasedLetters:
            return "El valor \(fieldName) debe tener alguna mayúscula."
        case .hasNumbers:
            return "El valor \(fieldName) debe tener algún número."
        }
    }
}

struct Validation: Identifiable {
    var id: Int
    var field: Field
    var validationType: ValidationType
    var state: ValidationState
    
    init(string: String, id: Int, field: Field, validationType: ValidationType) {
        self.id = id
        self.field = field
        self.validationType = validationType
        self.state = validationType.fulfills(string: string) ? .success : .failure
    }
}
