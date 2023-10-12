//
//  EBookModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// EBook data type. A struct used to contain all the properties that describes an electronic or digital book or ebook.
/// Some of these properties are author, book title, original title and so on. All the properties are required and have to be initialised, with the exception of synopsis and cover that can be nil.
struct EBooks: Codable, Identifiable, Equatable, BooksProtocol {
	let id: Int
	let author: String
	let bookTitle: String
	let originalTitle: String
	let year: Int
	let pages: Int
	let price: Double
	var owner: String
	var status: ReadingStatus
	var synopsis: String? = nil
	var cover: String? = nil
}


/// A protocol to which Books and EBooks needs to conform to, so those two data types can be input in a function using generics.
protocol BooksProtocol {
	var pages: Int { get }
	var price: Double { get }
	var status: ReadingStatus { get set }
}
