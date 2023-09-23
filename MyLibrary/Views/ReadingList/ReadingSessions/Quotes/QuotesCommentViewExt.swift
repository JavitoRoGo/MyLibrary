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
		if let index = model.userLogic.user.sessions.firstIndex(of: session) {
			model.userLogic.user.sessions[index].comment = nil
		}
		// Borrar comentario de la sesión del libro en ReadingDatas, en caso de existir
		if let bookIndex = model.userLogic.user.readingDatas.firstIndex(where: { $0.readingSessions.contains(session) }),
		   let sessionIndex = model.userLogic.user.readingDatas[bookIndex].readingSessions.firstIndex(of: session) {
			model.userLogic.user.readingDatas[bookIndex].readingSessions[sessionIndex].comment = nil
		}
		// Borrar comentario de la sesión del libro en NowReading, en caso de existir
		if let bookIndex = model.userLogic.user.nowReading.firstIndex(where: { $0.sessions.contains(session) }),
		   let sessionIndex = model.userLogic.user.nowReading[bookIndex].sessions.firstIndex(of: session) {
			model.userLogic.user.nowReading[bookIndex].sessions[sessionIndex].comment = nil
		}
		// Borrar comentario de la sesión de la vista actual
		self.session.comment = nil
	}
	
	func deleteQuote(from session: ReadingSession, quote: Quote) {
		// Borrar cita del listado global de sesiones
		if let index = model.userLogic.user.sessions.firstIndex(of: session) {
			model.userLogic.user.sessions[index].quotes?.removeAll(where: { $0 == quote })
			if let _ = model.userLogic.user.sessions[index].quotes?.isEmpty {
				model.userLogic.user.sessions[index].quotes = nil
			}
		}
		// Borar cita de la sesión del libro en ReadingDatas, en caso de existir
		if let bookIndex = model.userLogic.user.readingDatas.firstIndex(where: { $0.readingSessions.contains(session) }),
		   let sessionIndex = model.userLogic.user.readingDatas[bookIndex].readingSessions.firstIndex(of: session) {
			model.userLogic.user.readingDatas[bookIndex].readingSessions[sessionIndex].quotes?.removeAll(where: { $0 == quote })
			if let _ = model.userLogic.user.readingDatas[bookIndex].readingSessions[sessionIndex].quotes?.isEmpty {
				model.userLogic.user.readingDatas[bookIndex].readingSessions[sessionIndex].quotes = nil
			}
		}
		// Borrar cita de la sesión del libro en NowReading, en caso de existir
		if let bookIndex = model.userLogic.user.nowReading.firstIndex(where: { $0.sessions.contains(session) }),
		   let sessionIndex = model.userLogic.user.nowReading[bookIndex].sessions.firstIndex(of: session) {
			model.userLogic.user.nowReading[bookIndex].sessions[sessionIndex].quotes?.removeAll(where: { $0 == quote })
			if let _ = model.userLogic.user.nowReading[bookIndex].sessions[sessionIndex].quotes?.isEmpty {
				model.userLogic.user.nowReading[bookIndex].sessions[sessionIndex].quotes = nil
			}
		}
		// Borrar cita de la sesión de la vista actual
		self.session.quotes?.removeAll(where: { $0 == quote })
		if let _ = session.quotes?.isEmpty {
			self.session.quotes = nil
		}
	}
}
