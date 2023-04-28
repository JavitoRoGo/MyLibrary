//
//  AddRS.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 26/2/22.
//

import SwiftUI

struct AddRS: View {
    @ObservedObject var wcmodel = ConnectivityMaganer()
    
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var nrmodel: NowReadingModel
    @EnvironmentObject var rsmodel: ReadingSessionModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var book: NowReading
    
    @State private var sessionDate: Date = .now
    @State var startingPage: Int
    @State private var endingPage: Int = 0
    @State var hour: Int
    @State var minute: Int
    @FocusState private var isFocused: Bool
    @State private var addingComment = false
    @State private var commentText = ""
    
    @State private var showingDailyAchivedAlert = false
    @State private var showingWeeklyAchivedAlert = false
    
    @State private var existingTime = 0
    @State private var showingExistingTimeAlert = false
    
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
    
    var isDisabled: Bool {
        guard startingPage == 0 || endingPage == 0 || startingPage > endingPage ||
        (hour == 0 && minute == 0) else { return false }
        return true
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
                if rsmodel.tempQuotesArray.isEmpty {
                    Text("No has añadido ninguna cita en esta sesión")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(rsmodel.tempQuotesArray, id:\.date) { quote in
                        Text(quote.text)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    rsmodel.tempQuotesArray.removeAll(where: { $0 == quote })
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
            } header: {
                Text("Citas")
            } footer: {
                if !rsmodel.tempQuotesArray.isEmpty {
                    Text("Desliza hacia la izquierda si quieres eliminar alguna de las citas.")
                }
            }
        }
        .navigationTitle(book.bookTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancelar") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Añadir") {
                    addSession()
                }
                .disabled(isDisabled)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Listo") {
                    isFocused = false
                }
            }
        }
        .alert("¡Enhorabuena!", isPresented: $showingDailyAchivedAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Has alcanzado tu objetivo diario de lectura.")
        }
        .alert("¡Enhorabuena!", isPresented: $showingWeeklyAchivedAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("Has alcanzado tu objetivo semanal de lectura.")
        }
        .alert("Existe una sesión iniciada en tu AppleWatch.", isPresented: $showingExistingTimeAlert) {
            Button("Descartar", role: .cancel) {
                wcmodel.readingTime = 0
            }
            Button("Añadir") {
                hour += existingTime / 60
                minute += existingTime % 60
                wcmodel.readingTime = 0
            }
        } message: {
            Text("¿Deseas sumar la duración de esa sesión?")
        }
        .onAppear {
            existingTime = wcmodel.readingTime
            if existingTime != 0 {
                showingExistingTimeAlert = true
            }
        }
    }
    
    func addSession() {
        guard let index = nrmodel.readingList.firstIndex(of: book) else { return }
        if endingPage >= book.lastPage {
            endingPage = book.lastPage
            nrmodel.readingList[index].isFinished = true
        }
        let newDate: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: sessionDate) ?? .now
        var newSession = ReadingSession(id: UUID(), date: newDate, duration: sessionDuration, startingPage: startingPage, endingPage: endingPage, minPerPag: minPerPag)
        if !commentText.isEmpty {
            newSession.comment = Quote(date: sessionDate, bookTitle: book.bookTitle, page: 0, text: commentText)
        }
        if !rsmodel.tempQuotesArray.isEmpty {
            newSession.quotes = rsmodel.tempQuotesArray
            rsmodel.tempQuotesArray.removeAll()
        }
        nrmodel.readingList[index].sessions.insert(newSession, at: 0)
        rsmodel.readingSessionList.insert(newSession, at: 0)
        
        if Calendar.current.component(.weekday, from: newDate) == 7 {
            let weekPages = rsmodel.calcTotalPagesPerWeekAndMonth(tag: 0).pages.reduce(0,+)
            let weekSessions = rsmodel.getSessions(tag: 0)
            let weekTime = weekSessions.reduce(0) { $0 + $1.readingTimeInHours }
            if weekPages >= model.weeklyPagesTarget || weekTime >= model.weeklyTimeTarget {
                showingWeeklyAchivedAlert = true
            }
        }
        if newSession.pages >= model.dailyPagesTarget || newSession.readingTimeInHours >= model.dailyTimeTarget {
            showingDailyAchivedAlert = true
        } else {
            dismiss()
        }
    }
}

struct AddRS_Previews: PreviewProvider {
    static let book = NowReading.example[0]
    
    static var previews: some View {
        NavigationView {
            AddRS(book: .constant(book), startingPage: book.nextPage, hour: 0, minute: 0)
                .environmentObject(UserViewModel())
                .environmentObject(NowReadingModel())
                .environmentObject(ReadingSessionModel())
        }
    }
}
