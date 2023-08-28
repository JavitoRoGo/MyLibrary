//
//  QuotesCommentViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import Foundation

extension QuotesCommentView {
	func deleteComment(from session: ReadingSession) {
		// Borrar comentario del listado global de sesiones
		if let index = model.user.sessions.firstIndex(of: session) {
			model.user.sessions[index].comment = nil
		}
		// Borrar comentario de la sesión del libro en ReadingDatas, en caso de existir
		if let bookIndex = model.user.readingDatas.firstIndex(where: { $0.readingSessions.contains(session) }),
		   let sessionIndex = model.user.readingDatas[bookIndex].readingSessions.firstIndex(of: session) {
			model.user.readingDatas[bookIndex].readingSessions[sessionIndex].comment = nil
		}
		// Borrar comentario de la sesión del libro en NowReading, en caso de existir
		if let bookIndex = model.user.nowReading.firstIndex(where: { $0.sessions.contains(session) }),
		   let sessionIndex = model.user.nowReading[bookIndex].sessions.firstIndex(of: session) {
			model.user.nowReading[bookIndex].sessions[sessionIndex].comment = nil
		}
		// Borrar comentario de la sesión de la vista actual
		self.session.comment = nil
	}
	
	func deleteQuote(from session: ReadingSession, quote: Quote) {
		// Borrar cita del listado global de sesiones
		if let index = model.user.sessions.firstIndex(of: session) {
			model.user.sessions[index].quotes?.removeAll(where: { $0 == quote })
			if let _ = model.user.sessions[index].quotes?.isEmpty {
				model.user.sessions[index].quotes = nil
			}
		}
		// Borar cita de la sesión del libro en ReadingDatas, en caso de existir
		if let bookIndex = model.user.readingDatas.firstIndex(where: { $0.readingSessions.contains(session) }),
		   let sessionIndex = model.user.readingDatas[bookIndex].readingSessions.firstIndex(of: session) {
			model.user.readingDatas[bookIndex].readingSessions[sessionIndex].quotes?.removeAll(where: { $0 == quote })
			if let _ = model.user.readingDatas[bookIndex].readingSessions[sessionIndex].quotes?.isEmpty {
				model.user.readingDatas[bookIndex].readingSessions[sessionIndex].quotes = nil
			}
		}
		// Borrar cita de la sesión del libro en NowReading, en caso de existir
		if let bookIndex = model.user.nowReading.firstIndex(where: { $0.sessions.contains(session) }),
		   let sessionIndex = model.user.nowReading[bookIndex].sessions.firstIndex(of: session) {
			model.user.nowReading[bookIndex].sessions[sessionIndex].quotes?.removeAll(where: { $0 == quote })
			if let _ = model.user.nowReading[bookIndex].sessions[sessionIndex].quotes?.isEmpty {
				model.user.nowReading[bookIndex].sessions[sessionIndex].quotes = nil
			}
		}
		// Borrar cita de la sesión de la vista actual
		self.session.quotes?.removeAll(where: { $0 == quote })
		if let _ = session.quotes?.isEmpty {
			self.session.quotes = nil
		}
	}
}
