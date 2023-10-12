//
//  QuoteModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Quote data type. A struct used to contain a quote from a concrete page of a book. All the properties are required and have to be initialised.
struct Quote: Codable, Equatable {
	let date: Date
	let bookTitle: String
	let page: Int
	let text: String
}
