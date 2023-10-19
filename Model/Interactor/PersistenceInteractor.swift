//
//  PersistenceInteractor.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/9/23.
//

import Foundation

/// A protocol to handle the app persistence.
///
/// It has two properties: one for the Bundle url and one for the sandbox url.
/// It also has two methods: one for loading data from either the bundle or the sandbox, and one for saving data to sandbox.
///
/// With this protocol we can handle preview data and production data, by defining or directioning ``bundleURL`` and ``docURL`` to one or the other.
protocol PersistenceInteractor {
	/// The url to the Bundle where the data originally exists.
	var bundleURL: URL { get }
	/// The url to the sandbox where the data can be saved and/or exists.
	var docURL: URL { get }
	
	/// A method to load data from either the Bundle or the sandbox.
	/// - Returns: A ``User`` instance containing the main data stored either in the Bundle or in the sandbox.
	func loadUser() throws -> User
	/// A method to store all the main data to sandbox.
	/// - Parameter user: A ``User`` instance containing all the main data.
	func saveUser(_ user: User) throws
}

extension PersistenceInteractor {
	func loadUser() throws -> User {
		var url = docURL
		if !FileManager.default.fileExists(atPath: url.path) {
			url = bundleURL
		}
		let data = try Data(contentsOf: url)
		return try JSONDecoder().decode(User.self, from: data)
	}
	
	func saveUser(_ user: User) throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let data = try encoder.encode(user)
		try data.write(to: docURL, options: .atomic)
	}
}


// Persistencia para producción

/// A struct conforming to ``PersistenceInteractor`` to handle the persistence of production data.
struct Persistence: PersistenceInteractor {
	var bundleURL: URL {
		Bundle.main.url(forResource: "USERDATA", withExtension: "json")!
	}
	
	var docURL: URL {
		URL.documentsDirectory.appending(path: "USERDATA.json")
	}
}
