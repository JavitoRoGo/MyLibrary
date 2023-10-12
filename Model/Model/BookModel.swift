//
//  BookModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Book data type. A struct used to contain all the properties that describes a physical book, a book with paper pages.
/// Some of these properties are author, book title, publisher and so on. All the properties are required and have to be initialised, with the exception of synopsis and cover that can be nil.
struct Books: Codable, Identifiable, Equatable, BooksProtocol {
	let id: Int
	let author: String
	var bookTitle: String
	let originalTitle: String
	let publisher: String
	let city: String
	let edition: Int
	let editionYear: Int
	let writingYear: Int
	let coverType: Cover
	let isbn1: Int
	let isbn2: Int
	let isbn3: Int
	let isbn4: Int
	let isbn5: Int
	let pages: Int
	let height: Double
	let width: Double
	let thickness: Double
	let weight: Int
	let price: Double
	var place: String
	var owner: String
	var status: ReadingStatus
	var isActive: Bool
	var synopsis: String?
	var cover: String? = nil
}
