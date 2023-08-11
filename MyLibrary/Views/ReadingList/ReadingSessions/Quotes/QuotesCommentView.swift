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
}

struct QuotesCommentView_Previews: PreviewProvider {
    static var previews: some View {
        QuotesCommentView(session: ReadingSession.example)
            .environmentObject(ReadingSessionModel())
            .environmentObject(NowReadingModel())
            .environmentObject(RDModel())
    }
}
