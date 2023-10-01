//
//  UserConfigViewGridExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 18/9/23.
//

import SwiftUI

extension UserConfigView {
	var gridButtons: some View {
		Section {
			Button {
				withAnimation {
					preferences.preferredGridView = false
				}
			} label: {
				HStack {
					Image(systemName: "list.star")
					Text("Listado de libros")
						.foregroundColor(.primary)
					Spacer()
					if !preferences.preferredGridView {
						Image(systemName: "checkmark")
							.animation(.easeIn)
					}
				}
			}
			Button {
				withAnimation {
					preferences.preferredGridView = true
				}
			} label: {
				HStack {
					Image(systemName: "square.grid.3x3")
					Text("Parrilla de portadas")
						.foregroundColor(.primary)
					Spacer()
					if preferences.preferredGridView {
						Image(systemName: "checkmark")
							.animation(.easeIn)
					}
				}
			}
		} footer: {
			Text("Elige la vista por defecto para los libros y ebooks.")
		}
	}
}
