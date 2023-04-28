//
//  QuotesCommentView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/1/23.
//

import SwiftUI

struct QuotesCommentView: View {
    @EnvironmentObject var rsmodel: ReadingSessionModel
    @EnvironmentObject var nrmodel: NowReadingModel
    @EnvironmentObject var rdmodel: RDModel
    @State var session: ReadingSession
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.secondary)
                .frame(width: 50, height: 5)
                .padding(.vertical)
            Text("Citas y comentarios")
            List {
                Section("Comentario a la sesión") {
                    Text(session.comment?.text ?? "Sin comentarios para esta sesión.")
                        .foregroundColor(session.comment?.text.isEmpty ?? true ? .secondary : .primary)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                deleteComment(from: session)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                }
                Section("Citas de la sesión") {
                    if let quotes = session.quotes {
                        ForEach(quotes, id:\.date) { quote in
                            VStack(alignment: .leading) {
                                Text("Recogida el \(quote.date.formatted(date: .numeric, time: .omitted)) en la página \(quote.page) de \(quote.bookTitle).")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text(quote.text)
                                    .bold()
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteQuote(from: session, quote: quote)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    } else {
                        Text("Sin citas para esta sesión.")
                            .foregroundColor(.secondary)
                    }
                }
            }
            Spacer()
        }
    }
    
    func deleteComment(from session: ReadingSession) {
        // Borrar comentario del listado global de sesiones
        if let index = rsmodel.readingSessionList.firstIndex(of: session) {
            rsmodel.readingSessionList[index].comment = nil
        }
        // Borrar comentario de la sesión del libro en ReadingDatas, en caso de existir
        if let bookIndex = rdmodel.readingDatas.firstIndex(where: { $0.readingSessions.contains(session) }),
           let sessionIndex = rdmodel.readingDatas[bookIndex].readingSessions.firstIndex(of: session) {
            rdmodel.readingDatas[bookIndex].readingSessions[sessionIndex].comment = nil
        }
        // Borrar comentario de la sesión del libro en NowReading, en caso de existir
        if let bookIndex = nrmodel.readingList.firstIndex(where: { $0.sessions.contains(session) }),
           let sessionIndex = nrmodel.readingList[bookIndex].sessions.firstIndex(of: session) {
            nrmodel.readingList[bookIndex].sessions[sessionIndex].comment = nil
        }
        // Borrar comentario de la sesión de la vista actual
        self.session.comment = nil
    }
    
    func deleteQuote(from session: ReadingSession, quote: Quote) {
        // Borrar cita del listado global de sesiones
        if let index = rsmodel.readingSessionList.firstIndex(of: session) {
            rsmodel.readingSessionList[index].quotes?.removeAll(where: { $0 == quote })
            if let _ = rsmodel.readingSessionList[index].quotes?.isEmpty {
                rsmodel.readingSessionList[index].quotes = nil
            }
        }
        // Borar cita de la sesión del libro en ReadingDatas, en caso de existir
        if let bookIndex = rdmodel.readingDatas.firstIndex(where: { $0.readingSessions.contains(session) }),
           let sessionIndex = rdmodel.readingDatas[bookIndex].readingSessions.firstIndex(of: session) {
            rdmodel.readingDatas[bookIndex].readingSessions[sessionIndex].quotes?.removeAll(where: { $0 == quote })
            if let _ = rdmodel.readingDatas[bookIndex].readingSessions[sessionIndex].quotes?.isEmpty {
                rdmodel.readingDatas[bookIndex].readingSessions[sessionIndex].quotes = nil
            }
        }
        // Borrar cita de la sesión del libro en NowReading, en caso de existir
        if let bookIndex = nrmodel.readingList.firstIndex(where: { $0.sessions.contains(session) }),
           let sessionIndex = nrmodel.readingList[bookIndex].sessions.firstIndex(of: session) {
            nrmodel.readingList[bookIndex].sessions[sessionIndex].quotes?.removeAll(where: { $0 == quote })
            if let _ = nrmodel.readingList[bookIndex].sessions[sessionIndex].quotes?.isEmpty {
                nrmodel.readingList[bookIndex].sessions[sessionIndex].quotes = nil
            }
        }
        // Borrar cita de la sesión de la vista actual
        self.session.quotes?.removeAll(where: { $0 == quote })
        if let _ = session.quotes?.isEmpty {
            self.session.quotes = nil
        }
    }
}

struct QuotesCommentView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesCommentView(session: ReadingSession.example)
            .environmentObject(ReadingSessionModel())
            .environmentObject(NowReadingModel())
            .environmentObject(RDModel())
    }
}
