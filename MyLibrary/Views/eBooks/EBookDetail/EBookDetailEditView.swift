//
//  EBookDetailEditView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EBookDetail {
	var editView: some View {
		VStack {
			HStack {
				Button("Cancelar") {
					showingEditPage = false
				}
				Spacer()
				Text("¿Editar?")
				Spacer()
				Button("Modificar") {
					ebook.status = newStatus
					showingEditPage = false
				}
			}
			.padding(.horizontal)
			Picker("Estado", selection: $newStatus) {
				ForEach(ReadingStatus.allCases, id: \.self) {
					Text($0.rawValue)
				}
			}
			.pickerStyle(.wheel)
			if newStatus == .notRead || newStatus == .reading || newStatus == .waiting {
				VStack {
					HStack {
						Text("¿Está en la lista de lectura?")
						Spacer()
						Image(systemName: isOnWaitingList ? "star.fill" : "star")
							.foregroundColor(isOnWaitingList ? .yellow : .gray.opacity(0.8))
					}
					Toggle("Añadir a la lista de lectura", isOn: $showingAddWaitingList)
						.foregroundColor(isOnWaitingList ? .secondary : .primary)
						.disabled(isOnWaitingList)
				}
				.padding(.horizontal)
			}
		}
	}
}
