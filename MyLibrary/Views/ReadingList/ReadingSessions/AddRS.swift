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
    
    @State var sessionDate: Date = .now
    @State var startingPage: Int
    @State var endingPage: Int = 0
    @State var hour: Int
    @State var minute: Int
    @FocusState var isFocused: Bool
    @State var addingComment = false
    @State var commentText = ""
    
    @State var showingDailyAchivedAlert = false
    @State var showingWeeklyAchivedAlert = false
    
    @State var existingTime = 0
    @State var showingExistingTimeAlert = false
    
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
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isFocused = true
                            }
                        }
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
		.modifier(AddRSModifier(book: $book, hour: $hour, minute: $minute, existingTime: $existingTime, showingDailyAchivedAlert: $showingDailyAchivedAlert, showingWeeklyAchivedAlert: $showingWeeklyAchivedAlert, showingExistingTimeAlert: $showingExistingTimeAlert, isDisabled: isDisabled, addSession: addSession))
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
