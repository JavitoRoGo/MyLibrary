//
//  RSListExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension RSList {
	func deleteSessionRow(_ session: ReadingSession) {
		if let index = model.user.nowReading.firstIndex(of: book) {
			model.user.sessions.removeAll(where: { $0 == session })
			model.user.nowReading[index].sessions.removeAll(where: { $0 == session })
			if book.isFinished {
				model.user.nowReading[index].isFinished = false
			}
		}
	}
	
	struct RSListModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		
		@Binding var book: NowReading
		@Binding var showingAddSession: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Sesiones de lectura")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					HStack {
						NavigationLink(destination: RSBarGraph(datas: model.datas(book: book), labels: model.getXLabels(book: book))) {
							Image(systemName: "chart.bar")
						}
						.disabled(book.sessions.isEmpty)
						Button {
							showingAddSession = true
						} label: {
							Label("Añadir", systemImage: "plus")
						}
						.disabled(book.isFinished || !book.isOnReading)
					}
				}
				.sheet(isPresented: $showingAddSession) {
					NavigationView {
						AddRS(book: $book, startingPage: book.nextPage, hour: 0, minute: 0)
					}
				}
		}
	}
}
