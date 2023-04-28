//
//  BookModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

final class BooksModel: ObservableObject {
    @Published var books: [Books] {
        didSet {
            Task { await saveToJson(booksJson, books) }
            UserViewModel().user.books = books
        }
    }
    
    init() {
        books = Bundle.main.searchAndDecode(booksJson) ?? []
    }
            
    var activeBooks: [Books] {
        books.filter{ $0.isActive }
    }
    
    func numAtPlace(_ place: String) -> Int {
        if place == "all" {
            return activeBooks.count
        }
        return booksAtPlace(place).count
    }
    
    func booksAtPlace(_ place: String) -> [Books] {
        books.filter { $0.place == place }.reversed()
    }
    
    func numByOwner(_ owner: String) -> Int {
        booksByOwner(owner).count
    }
    
    func booksByOwner(_ owner: String) -> [Books] {
        activeBooks.filter { $0.owner == owner }.reversed()
    }
    
    // Función de búsqueda de valores existentes: autor, editorial y ciudad
    func compareExistingData(tag: Int, text: String) -> (num: Int, datas: [String]) {
        var foundBookArray = [Books]()
        var arrayOfData = [String]()
        
        if tag == 0 {
            foundBookArray = activeBooks.filter { $0.author.lowercased().contains(text.lowercased()) }
            foundBookArray.forEach { book in
                arrayOfData.append(book.author)
            }
        } else if tag == 1 {
            foundBookArray = activeBooks.filter { $0.publisher.lowercased().contains(text.lowercased()) }
            foundBookArray.forEach { book in
                arrayOfData.append(book.publisher)
            }
        } else {
            foundBookArray = activeBooks.filter { $0.city.lowercased().contains(text.lowercased()) }
            foundBookArray.forEach { book in
                arrayOfData.append(book.city)
            }
        }
        
        let uniqueData = arrayOfData.uniqued()
        return (uniqueData.count, uniqueData)
    }
    
    
    // Cambiar la ubicación de libros en bloque
    func moveFromTo(from oldPlace: String, to newplace: String) {
        for book in books where book.place == oldPlace {
            if let index = books.firstIndex(of: book) {
                books[index].place = newplace
            }
        }
    }
    
    // Cambiar el propietario de libros en bloque
    func changeOwnerFromTo(from oldOwner: String, to newOwner: String) {
        for book in books where book.owner == oldOwner {
            if let index = books.firstIndex(of: book) {
                books[index].owner = newOwner
            }
        }
    }
    
    // Generar listado de ubicaciones sugeridas en función de los datos contenidos en los libros
    func getSuggestedPlacesFromData() -> [String] {
        var arrayOfData = [String]()
        activeBooks.forEach { book in
            arrayOfData.append(book.place)
        }
        return arrayOfData.uniqued().sorted()
    }
    
    // Generar listado de propietarios sugeridos en función de los datos contenidos en los libros
    func getSuggestedOwnersFromData() -> [String] {
        var arrayOfData = [String]()
        activeBooks.forEach { book in
            arrayOfData.append(book.owner)
        }
        return arrayOfData.uniqued().sorted()
    }
}

extension BooksModel {
    // Funciones para las estadísticas por ubicación
    
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
    func globalPages() -> (total: Int, mean: Int) {
        let total = activeBooks.reduce(0) { $0 + $1.pages }
        let mean = total / activeBooks.count
        return(total, mean)
    }
    
    func globalPrice() -> (total: Double, mean: Double) {
        let total = activeBooks.reduce(0) { $0 + $1.price }
        let mean = total / Double(activeBooks.count)
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
            return globalPages()
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
            return globalPrice()
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
        let myPlaces = UserViewModel().myPlaces
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
                let num = Double(numAtPlace(place))
                array.append(num)
            }
            return array
        }
    }
}

extension BooksModel {
    // Funciones para las otras estadísticas en SwiftCharts: por autor, editorial, encuadernación y propietario
    
    // Función para obtener el listado de autores, editoriales, encuadernaciones y propietarios
    func arrayOfLabelsByCategoryForPickerAndGraph(tag: Int) -> [String] {
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
            return numByOwner(text)
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
