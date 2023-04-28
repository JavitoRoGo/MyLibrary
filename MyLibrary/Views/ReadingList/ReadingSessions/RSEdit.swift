//
//  RSEdit.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/2/23.
//

import SwiftUI

struct RSEdit: View {
    @EnvironmentObject var nrmodel: NowReadingModel
    @EnvironmentObject var rsmodel: ReadingSessionModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var book: NowReading
    @Binding var session: ReadingSession
    
    @State private var sessionDate: Date = .now
    @State private var startingPage: Int = 0
    @State private var endingPage: Int = 0
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @FocusState private var isFocused: Bool
    @State private var addingComment = false
    @State private var commentText = ""
    @State private var quotes: [Quote] = []
    
    var sessionDuration: String {
        return "\(hour)h \(minute)min"
    }
    var minPerPag: String {
        let valueInMinutes = durationInMinutes / Double(endingPage - startingPage + 1)
        let float = valueInMinutes.truncatingRemainder(dividingBy: 1.0)
        let min = Int(valueInMinutes - float)
        let sec = Int(round(float * 60))
        return "\(min)min \(sec)s"
    }
    var durationInMinutes: Double {
        Double(hour * 60 + minute)
    }
    
    var hasChanged: Bool {
        let newDateChanges: Bool
        if sessionDate != session.date {
            newDateChanges = true
        } else {
            newDateChanges = false
        }
        
        let startingPageChanges: Bool
        if startingPage != session.startingPage {
            startingPageChanges = true
        } else {
            startingPageChanges = false
        }
        
        let endingPageChanges: Bool
        if endingPage != session.endingPage {
            endingPageChanges = true
        } else {
            endingPageChanges = false
        }
        
        let hourChanges: Bool
        if hour != Int(session.readingTimeInHours) {
            hourChanges = true
        } else {
            hourChanges = false
        }
        
        let minuteChanges: Bool
        if minute != Int((session.readingTimeInHours.truncatingRemainder(dividingBy: 1.0)) * 60) {
            minuteChanges = true
        } else {
            minuteChanges = false
        }
        
        let commentChanges: Bool
        if let comment = session.comment {
            if commentText != comment.text {
                commentChanges = true
            } else {
                commentChanges = false
            }
        } else {
            if !commentText.isEmpty {
                commentChanges = true
            } else {
                commentChanges = false
            }
        }
        
        let quotesChanges: Bool
        if let quotes = session.quotes {
            if self.quotes != quotes {
                quotesChanges = true
            } else {
                quotesChanges = false
            }
        } else {
            quotesChanges = false
        }
        
        if newDateChanges || startingPageChanges || endingPageChanges || hourChanges || minuteChanges || commentChanges || quotesChanges {
            return true
        }
        return false
    }
    
    var body: some View {
        Form {
            Section {
                DatePicker("Fecha", selection: $sessionDate, in: ...Date.now, displayedComponents: .date)
            }
            Section {
                HStack {
                    Text("Página inicial")
                    Spacer()
                    TextField("", value: $startingPage, format: .number)
                        .multilineTextAlignment(.trailing)
                        .focused($isFocused)
                }
                HStack {
                    Text("Página final")
                    Spacer()
                    TextField("", value: $endingPage, format: .number)
                        .multilineTextAlignment(.trailing)
                        .focused($isFocused)
                }
            }
            .keyboardType(.numberPad)
            Section {
                HStack {
                    Text("Duración")
                    Spacer()
                    Picker("hour", selection: $hour) {
                        ForEach(0..<5) {
                            Text("\($0)h")
                        }
                    }
                    Picker("min", selection: $minute) {
                        ForEach(0..<60, id: \.self) {
                            Text("\($0)min")
                        }
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)
            }
            Section {
                Toggle("Añade un comentario a esta sesión", isOn: $addingComment)
                if addingComment {
                    TextEditor(text: $commentText)
                        .frame(height: 150)
                }
            }
            Section {
                if quotes.isEmpty {
                    Text("No has añadido ninguna cita en esta sesión")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(quotes, id:\.date) { quote in
                        Text(quote.text)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    quotes.removeAll(where: { $0 == quote })
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
            } header: {
                Text("Citas")
            } footer: {
                if !quotes.isEmpty {
                    Text("Desliza hacia la izquierda si quieres eliminar alguna de las citas.")
                }
            }
        }
        .navigationTitle("Modifica la sesión")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Modificar") {
                    modifySession()
                    dismiss()
                }
                .disabled(!hasChanged)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    isFocused = false
                }
            }
        }
        .onAppear {
            loadSessionData()
        }
    }
    
    func loadSessionData() {
        sessionDate = session.date
        startingPage = session.startingPage
        endingPage = session.endingPage
        hour = Int(session.readingTimeInHours)
        minute = Int((session.readingTimeInHours.truncatingRemainder(dividingBy: 1.0)) * 60)
        if let comment = session.comment {
            commentText = comment.text
            addingComment = true
        }
        if let quotes = session.quotes {
            self.quotes = quotes
        }
    }
    
    func modifySession() {
        guard let index = nrmodel.readingList.firstIndex(of: book) else { return }
        if endingPage >= book.lastPage {
            endingPage = book.lastPage
            nrmodel.readingList[index].isFinished = true
        }
        let newDate: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: sessionDate) ?? .now
        session = ReadingSession(id: session.id, date: newDate, duration: sessionDuration, startingPage: startingPage, endingPage: endingPage, minPerPag: minPerPag)
        if !commentText.isEmpty {
            session.comment = Quote(date: sessionDate, bookTitle: book.bookTitle, page: 0, text: commentText)
        }
        if !quotes.isEmpty {
            session.quotes = quotes
        }
        if let bookSessionIndex = nrmodel.readingList[index].sessions.firstIndex(where: { $0.id == session.id }),
           let sessionIndex = rsmodel.readingSessionList.firstIndex(where: { $0.id == session.id }) {
            nrmodel.readingList[index].sessions[bookSessionIndex] = session
            rsmodel.readingSessionList[sessionIndex] = session
        }
    }
}

struct RSEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RSEdit(book: .constant(NowReading.example[0]), session: .constant(ReadingSession.example))
                .environmentObject(NowReadingModel())
            .environmentObject(ReadingSessionModel())
        }
    }
}
