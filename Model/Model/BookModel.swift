//
//  BookModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Book data type.
///
/// A struct used to contain all the properties that describes a physical book, a book with paper pages.
/// Some of these properties are `author`, `book title`, `publisher` and so on. All the properties are required and have to be initialised, with the exception of `synopsis` and `cover` that can be nil.
struct Books: Codable, Identifiable, Equatable, BooksProtocol {
	/// An unique identifier for each book. It's a consecutive number generated when creating a new instance of ``Books``.
	let id: Int
	/// The author of each book.
	let author: String
	/// The book title as it is in user's language.
	var bookTitle: String
	/// The book title in the original language it was written.
	let originalTitle: String
	/// The company name that publishes the book.
	let publisher: String
	/// The city where the `Publisher` is set.
	let city: String
	/// The number of the current publication.
	let edition: Int
	/// The year of the current publication.
	let editionYear: Int
	/// The year when the book was originally written.
	let writingYear: Int
	/// Choose among three types of making of: hard-cover, pocket and flap-pocket.
	let coverType: Cover
	/// First of five items that an ISBN number has. It's usually 978.
	let isbn1: Int
	/// Second of five items that an ISBN number has. It's usually 84.
	let isbn2: Int
	/// Third of five items that an ISBN number has.
	let isbn3: Int
	/// Fourth of five items that an ISBN number has.
	let isbn4: Int
	/// Fifth of five items that an ISBN number has.
	let isbn5: Int
	/// Total pages that a book has.
	let pages: Int
	/// The height in cm of the front cover.
	let height: Double
	/// The width in cm of the front cover.
	let width: Double
	/// The thickness in cm of the book spine.
	let thickness: Double
	/// The weight in grams of the book.
	let weight: Int
	let price: Double
	/// Where the book is placed. This property can have whichever name the user wants.
	var place: String
	/// A person who is the owner of the book, in case the user wants to specify some different owners.
	var owner: String
	var status: ReadingStatus
	/// It shows wether the book is actually in user's library and belongs to him, or the book has been sold out or donated.
	var isActive: Bool
	/// The synopsis as it appears in the back cover.
	var synopsis: String?
	/// It contains the file name of the image that represents the book. It is set using ``imageCoverName(from:)`` function from `bookTitle`.
	///
	/// ```swift
	/// book.cover = imageCoverName(from: book.bookTitle)
	/// ```
	var cover: String? = nil
}
