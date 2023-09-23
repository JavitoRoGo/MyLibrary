//
//  RSRow.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 25/2/22.
//

import SwiftUI

struct RSRow: View {
    @State var session: ReadingSession
    @State private var showingQuotes = false
    
    var formattedDate: String {
        session.date.formatted(date: .long, time: .omitted)
    }
    var isThereAQuote: Bool {
        guard (session.quotes != nil) else { return false }
        return true
    }
    var isThereAComment: Bool {
        guard (session.comment != nil) else { return false }
        return true
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formattedDate)
                    .font(.body)
                Text("\(session.pages) páginas leídas en \(session.duration) (\(session.startingPage) - \(session.endingPage))")
                    .foregroundColor(session.pages >= 50 ? .green.opacity(0.9) : .primary)
                Text("\(session.minPerPag) por página")
            }
            Spacer()
            if isThereAQuote || isThereAComment {
                Button {
                    showingQuotes = true
                } label: {
                    Image(systemName: "quote.bubble")
                        .font(.title3)
                        .foregroundColor(.pink)
                }
            }
        }
        .font(.caption)
        .sheet(isPresented: $showingQuotes) {
            QuotesCommentView(session: session)
        }
    }
}

struct RSRow_Previews: PreviewProvider {
    static var previews: some View {
        RSRow(session: ReadingSession.dataTest)
            .previewLayout(.sizeThatFits)
    }
}
