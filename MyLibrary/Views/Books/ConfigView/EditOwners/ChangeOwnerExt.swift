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
				return model.userLogic.numberOfBooksByOwner(oldOwner)
			case .ebook:
				return model.userLogic.numberOfEbooksByOwner(oldOwner)
			case .all:
				return model.userLogic.numberOfBooksByOwner(oldOwner) + model.userLogic.numberOfEbooksByOwner(oldOwner)
		}
	}
	
	struct ChangeOwnerModifier: ViewModifier {
		@Environment(GlobalViewModel.self) var model
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
								model.userLogic.changeBookOwnerFromTo(from: oldOwner, to: newOwner)
							case .ebook:
								model.userLogic.changeEbookOwnerFromTo(from: oldOwner, to: newOwner)
							case .all:
								model.userLogic.changeBookOwnerFromTo(from: oldOwner, to: newOwner)
								model.userLogic.changeEbookOwnerFromTo(from: oldOwner, to: newOwner)
						}
						dismiss()
					}
				} message: {
					Text("¿Estás seguro?")
				}
		}
	}
}
