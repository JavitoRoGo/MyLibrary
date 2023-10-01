//
//  RSListExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension RSList {
	func deleteSessionRow(_ session: ReadingSession) {
		if let index = model.userLogic.user.nowReading.firstIndex(of: book) {
			model.userLogic.user.sessions.removeAll(where: { $0 == session })
			model.userLogic.user.nowReading[index].sessions.removeAll(where: { $0 == session })
			if book.isFinished {
				model.userLogic.user.nowReading[index].isFinished = false
			}
		}
	}
	
	struct RSListModifier: ViewModifier {
		@Environment(GlobalViewModel.self) var model
		
		@Binding var book: NowReading
		@Binding var showingAddSession: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Sesiones de lectura")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					HStack {
						NavigationLink(destination: RSBarGraph(datas: model.userLogic.datas(book: book), labels: model.userLogic.getXLabels(book: book))) {
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
