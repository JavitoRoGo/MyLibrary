//
//  BookModelExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

// Extension for BooksModel: handling with paper formatt books

extension UserLogic {
    
    var activeBooks: [Books] {
		user.books.filter{ $0.isActive }
    }
    
	func booksAtPlace(_ place: String) -> [Books] {
		user.books.filter { $0.place == place }.reversed()
	}
	
	func numberOfBooksAtPlace(_ place: String) -> Int {
        if place == "all" {
            return activeBooks.count
        }
        return booksAtPlace(place).count
    }
    
	func booksByOwner(_ owner: String) -> [Books] {
		activeBooks.filter { $0.owner == owner }.reversed()
	}
	
	func numberOfBooksByOwner(_ owner: String) -> Int {
        booksByOwner(owner).count
    }
    
	func booksByStatus(_ status: ReadingStatus) -> [Books] {
		activeBooks.filter { $0.status == status }.reversed()
	}
	
	func numberOfBooksByStatus(_ status: ReadingStatus) -> Int {
		booksByStatus(status).count
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
		for book in user.books where book.place == oldPlace {
			if let index = user.books.firstIndex(of: book) {
				user.books[index].place = newplace
            }
        }
    }
    
    // Cambiar el propietario de libros en bloque
    func changeBookOwnerFromTo(from oldOwner: String, to newOwner: String) {
		for book in user.books where book.owner == oldOwner {
			if let index = user.books.firstIndex(of: book) {
				user.books[index].owner = newOwner
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
