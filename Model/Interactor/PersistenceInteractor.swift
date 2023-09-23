//
//  PersistenceInteractor.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/9/23.
//

import Foundation

protocol PersistenceInteractor {
	var bundleURL: URL { get }
	var docURL: URL { get }
	
	func loadUser() throws -> User
	func saveUser(_ user: User) throws
}

extension PersistenceInteractor {
	func loadUser() throws -> User {
		var url = docURL
		if !FileManager.default.fileExists(atPath: url.path) {
			url = bundleURL
		}
		print(url.absoluteString)
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

struct Persistence: PersistenceInteractor {
	var bundleURL: URL {
		Bundle.main.url(forResource: "USERDATA", withExtension: "json")!
	}
	
	var docURL: URL {
		URL.documentsDirectory.appending(path: "USERDATA.json")
	}
}
