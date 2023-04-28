//
//  RSList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 25/2/22.
//

import SwiftUI

struct RSList: View {
    @EnvironmentObject var model: NowReadingModel
    @EnvironmentObject var rsmodel: ReadingSessionModel
    
    @State var book: NowReading
    @State private var showingAddSession = false
    
    var body: some View {
        List {
            Section(book.bookTitle) {
                ForEach(book.sessions) { session in
                    if let index = book.sessions.firstIndex(of: session) {
                        NavigationLink(destination: RSEdit(book: $book, session: $book.sessions[index])) {
                            RSRow(session: session)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        deleteSessionRow(session)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .disabled(!book.isOnReading)
                                }
                        }
                    }
                }
            }
        }
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
    
    func deleteSessionRow(_ session: ReadingSession) {
        if let index = model.readingList.firstIndex(of: book) {
            rsmodel.readingSessionList.removeAll(where: { $0 == session })
            model.readingList[index].sessions.removeAll(where: { $0 == session })
            if book.isFinished {
                model.readingList[index].isFinished = false
            }
        }
    }
}

struct RSList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RSList(book: NowReading.example[0])
                .environmentObject(NowReadingModel())
                .environmentObject(ReadingSessionModel())
        }
    }
}
