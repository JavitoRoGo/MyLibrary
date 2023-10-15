//
//  QuoteModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Quote data type.
///
/// A struct used to contain a quote from a concrete page of a book. It is also used to store a reading session comment.
/// All the properties are required and have to be initialised.
struct Quote: Codable, Equatable {
	/// Date when the quote is created.
	let date: Date
	/// The title of the book that contains the quote.
	let bookTitle: String
	/// The page number that contains the quote.
	let page: Int
	/// The text of the quote itself.
	let text: String
}
