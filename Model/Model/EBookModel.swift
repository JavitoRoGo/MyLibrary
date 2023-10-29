//
//  EBookModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// EBook data type.
///
/// A struct used to contain all the properties that describes an electronic or digital book or ebook.
/// Some of these properties are author, book title, original title and so on. All the properties are required and have to be initialised, with the exception of synopsis and cover that can be nil.
struct EBooks: Codable, Identifiable, Equatable, BooksProtocol {
	/// An unique identifier for each ebook. It's a consecutive number generated when creating a new instance of ``EBooks``.
	let id: Int
	/// The author of each ebook.
	let author: String
	/// The book title as it is in user's language.
	let bookTitle: String
	/// The book title in the original language it was written.
	let originalTitle: String
	/// The year when the book was originally written.
	let year: Int
	let pages: Int
	let price: Double
	/// A person who is the owner of the book, in case the user wants to specify some different owners.
	var owner: String
	var status: ReadingStatus
	/// The synopsis as it appears in the ebook.
	var synopsis: String? = nil
	/// It contains the file name of the image that represents the ebook. It is set using ``imageCoverName(from:)`` function from `bookTitle`.
	///
	/// ```swift
	/// ebook.cover = imageCoverName(from: ebook.bookTitle)
	/// ```
	var cover: String? = nil
}


/// A protocol to which Books and EBooks needs to conform to, so those two data types can be input in a function using generics.
protocol BooksProtocol {
	/// Total pages that a book or ebook has.
	var pages: Int { get }
	/// The price paid for a book or ebook, in local currency. The currency used must be the same for all the app.
	var price: Double { get }
}
