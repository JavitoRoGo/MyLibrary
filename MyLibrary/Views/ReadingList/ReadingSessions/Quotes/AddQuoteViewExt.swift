//
//  AddQuoteViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension AddQuoteView {
	struct AddQuoteModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		@Environment(\.dismiss) var dismiss
		
		let bookTitle: String
		let date: Date
		let page: Int
		let text: String
		
		@State var showingSavingAlert = false
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Crear cita")
				.navigationBarTitleDisplayMode(.inline)
				.autocorrectionDisabled(true)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancelar") {
							dismiss()
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Crear") {
							let newQuote = Quote(date: date, bookTitle: bookTitle, page: page, text: text)
							model.tempQuotesArray.insert(newQuote, at: 0)
							showingSavingAlert = true
						}
						.disabled(page == 0 || text.isEmpty)
					}
				}
				.alert("La cita se ha creado correctamente.", isPresented: $showingSavingAlert) {
					Button("OK") {
						dismiss()
					}
				} message: {
					Text("Podrás ver todas las citas creadas al finalizar la sesión actual de lectura.")
				}
		}
	}
}
