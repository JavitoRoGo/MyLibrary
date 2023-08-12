//
//  ChangeOwnerExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension ChangeBooksOwner {
	enum BookFormat: String, CaseIterable {
		case book = "Libros"
		case ebook = "eBooks"
		case all = "Todos"
	}
	
	var number: Int {
		switch format {
			case .book:
				return bmodel.numByOwner(oldOwner)
			case .ebook:
				return emodel.numByOwner(oldOwner)
			case .all:
				return bmodel.numByOwner(oldOwner) + emodel.numByOwner(oldOwner)
		}
	}
	
	struct ChangeOwnerModifier: ViewModifier {
		@EnvironmentObject var bmodel: BooksModel
		@EnvironmentObject var emodel: EbooksModel
		@Environment(\.dismiss) var dismiss
		
		@Binding var showingAlert: Bool
		
		let format: BookFormat
		let oldOwner: String
		let newOwner: String
		let number: Int
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Cambio masivo de propietario")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Mover") {
							showingAlert.toggle()
						}
						.disabled(oldOwner == newOwner || oldOwner.isEmpty || newOwner.isEmpty)
					}
				}
				.alert("Esto cambiará el propietario de \(number) \(format == .all ? "registros" : format.rawValue.lowercased()), de \(oldOwner) a \(newOwner).", isPresented: $showingAlert) {
					Button("No", role: .cancel) { }
					Button("Sí") {
						switch format {
							case .book:
								bmodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
							case .ebook:
								emodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
							case .all:
								bmodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
								emodel.changeOwnerFromTo(from: oldOwner, to: newOwner)
						}
						dismiss()
					}
				} message: {
					Text("¿Estás seguro?")
				}
		}
	}
}
