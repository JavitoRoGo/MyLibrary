//
//  EBookModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

final class EbooksModel: ObservableObject {
    @Published var ebooks: [EBooks] {
        didSet {
            Task { await saveToJson(ebooksJson, ebooks) }
            UserViewModel().user.ebooks = ebooks
        }
    }
    
    init() {
        ebooks = Bundle.main.searchAndDecode(ebooksJson) ?? []
    }
    
    func compareExistingAuthors(text: String) -> (num: Int, authors: [String]) {
        let foundEBookArray = ebooks.filter { $0.author.lowercased().contains(text.lowercased()) }
        var authorTotalArray = [String]()
        
        foundEBookArray.forEach { book in
            authorTotalArray.append(book.author)
        }
        
        return (authorTotalArray.uniqued().count, authorTotalArray.uniqued())
    }
    
    func numByOwner(_ owner: String) -> Int {
        ebooksByOwner(owner).count
    }
    
    func numByStatus(_ status: ReadingStatus) -> Int {
        ebooks.filter{ $0.status == status }.count
    }
    
    func ebooksByOwner(_ owner: String) -> [EBooks] {
        ebooks.filter { $0.owner == owner }.reversed()
    }
    
    // Cambiar el propietario de ebooks en bloque
    func changeOwnerFromTo(from oldOwner: String, to newOwner: String) {
        for ebook in ebooks where ebook.owner == oldOwner {
            if let index = ebooks.firstIndex(of: ebook) {
                ebooks[index].owner = newOwner
            }
        }
    }
    
    // MARK: - Funciones para las estadísticas
    
    // Datos globales
    func globalPages() -> (total: Int, mean: Int) {
        let total = ebooks.reduce(0) { $0 + $1.pages }
        let mean = total / ebooks.count
        return(total, mean)
    }
    
    func globalPrice() -> (total: Double, mean: Double) {
        let total = ebooks.reduce(0) { $0 + $1.price }
        let mean = total / Double(ebooks.count)
        return (total, mean)
    }
    
    // Función para obtener el listado de autores y propietarios
    func arrayOfLabelsByCategoryForPickerAndGraph(tag: Int) -> [String] {
        var arrayOfData = [String]()
        
        // Por autor:
        if tag == 0 {
            ebooks.forEach { ebook in
                arrayOfData.append(ebook.author)
            }
        } // Por propietario:
        else if tag == 1 {
            UserViewModel().myOwners.forEach { owner in
                arrayOfData.append(owner)
            }
        } // Por estado:
        else if tag == 2 {
            ReadingStatus.allCases.forEach { status in
                arrayOfData.append(status.rawValue)
            }
        }
        
        return arrayOfData.uniqued().sorted()
    }
    
    // Función para obtener el número de libros y resto de datos para estadísticas según el valor del picker
    func numOfEBooksForStats(tag: Int, text: String) -> Int {
        // Por autor:
        if tag == 0 {
            return ebooks.filter{ $0.author == text }.count
        } // Por propietario:
        else if tag == 1 {
            return numByOwner(text)
        } // Por estado:
        else if tag == 2 {
            guard let status = ReadingStatus.init(rawValue: text) else { return 0 }
            return ebooks.filter{ $0.status == status }.count
        }
        return 0
    }
    
    func numOfPagesForStats(tag: Int, text: String) -> (total: Int, mean: Int) {
        // Por autor:
        if tag == 0 {
            let ebooks = ebooks.filter{ $0.author == text }
            if !ebooks.isEmpty {
                let total = ebooks.reduce(0) { $0 + $1.pages }
                let mean = total / ebooks.count
                return (total, mean)
            }
        } // Por propietario:
        else if tag == 1 {
            let ebooks = ebooksByOwner(text)
            if !ebooks.isEmpty {
                let total = ebooks.reduce(0) { $0 + $1.pages }
                let mean = total / ebooks.count
                return (total, mean)
            }
        } // Por estado:
        else if tag == 2 {
            guard let status = ReadingStatus.init(rawValue: text) else { return (0,0) }
            let ebooks = ebooks.filter{ $0.status == status }
            if !ebooks.isEmpty {
                let total = ebooks.reduce(0) { $0 + $1.pages }
                let mean = total / ebooks.count
                return (total, mean)
            }
        }
        return(0, 0)
    }
    
    func priceForStats(tag: Int, text: String) -> (total: Double, mean: Double) {
        // Por autor:
        if tag == 0 {
            let ebooks = ebooks.filter{ $0.author == text }
            if !ebooks.isEmpty {
                let total = ebooks.reduce(0) { $0 + $1.price }
                let mean = total / Double(ebooks.count)
                return (total, mean)
            }
        } // Por propietario:
        else if tag == 1 {
            let ebooks = ebooksByOwner(text)
            if !ebooks.isEmpty {
                let total = ebooks.reduce(0) { $0 + $1.price }
                let mean = total / Double(ebooks.count)
                return (total, mean)
            }
        } // Por estado:
        else if tag == 2 {
            guard let status = ReadingStatus.init(rawValue: text) else { return (0,0) }
            let ebooks = ebooks.filter{ $0.status == status }
            if !ebooks.isEmpty {
                let total = ebooks.reduce(0) { $0 + $1.price }
                let mean = total / Double(ebooks.count)
                return (total, mean)
            }
        }
        return(0.0, 0.0)
    }
    
    // Función para obtener los datos a representar en las gráficas:
    func datasForGraph(statName: Int, dataName: Int, text: String) -> Double {
        // statName viene del picker (autor, propietario...), dataName viene del menú (libros, páginas...), y text es el texto a buscar
        if statName == 0 {
            // Por autor:
            switch dataName {
            case 1:
                // Número de páginas
                return Double(numOfPagesForStats(tag: statName, text: text).total)
            case 2:
                // Precio
                return priceForStats(tag: statName, text: text).total
            default:
                // Número de libros
                return Double(numOfEBooksForStats(tag: statName, text: text))
            }
        } else if statName == 1 {
            // Por propietario:
            switch dataName {
            case 1:
                // Número de páginas
                return Double(numOfPagesForStats(tag: statName, text: text).total)
            case 2:
                // Precio
                return priceForStats(tag: statName, text: text).total
            default:
                // Número de libros
                return Double(numOfEBooksForStats(tag: statName, text: text))
            }
        } else if statName == 2 {
            // Por estado:
            switch dataName {
            case 1:
                // Número de páginas
                return Double(numOfPagesForStats(tag: statName, text: text).total)
            case 2:
                // Precio
                return priceForStats(tag: statName, text: text).total
            default:
                // Número de libros
                return Double(numOfEBooksForStats(tag: statName, text: text))
            }
        }
        return 0.0
    }
}
