//
//  RSListExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension RSList {
	func deleteSessionRow(_ session: ReadingSession) {
		if let index = model.readingList.firstIndex(of: book) {
			rsmodel.readingSessionList.removeAll(where: { $0 == session })
			model.readingList[index].sessions.removeAll(where: { $0 == session })
			if book.isFinished {
				model.readingList[index].isFinished = false
			}
		}
	}
	
	struct RSListModifier: ViewModifier {
		@EnvironmentObject var rsmodel: ReadingSessionModel
		
		@Binding var book: NowReading
		@Binding var showingAddSession: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Sesiones de lectura")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					HStack {
						NavigationLink(destination: RSBarGraph(datas: rsmodel.datas(book: book), labels: rsmodel.getXLabels(book: book))) {
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
