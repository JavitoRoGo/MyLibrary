//
//  ExportingHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 19/9/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct JsonExportingDocument: FileDocument {
	var datasToExport: User = User.emptyUser
	init(_ datas: User) {
		self.datasToExport = datas
	}
	
	static var readableContentTypes: [UTType] = [.json]
	
	init(configuration: ReadConfiguration) throws {
		if let data = configuration.file.regularFileContents {
			datasToExport = try JSONDecoder().decode(User.self, from: data)
		}
	}
	
	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let data = try encoder.encode(datasToExport)
		return FileWrapper(regularFileWithContents: data)
	}
}
