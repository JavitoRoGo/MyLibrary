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
    
    @Binding var book: NowReading
    @Binding var session: ReadingSession
    
    @State var sessionDate: Date = .now
    @State var startingPage: Int = 0
    @State var endingPage: Int = 0
    @State var hour: Int = 0
    @State var minute: Int = 0
    @FocusState var isFocused: Bool
    @State var addingComment = false
    @State var commentText = ""
    @State var quotes: [Quote] = []
    
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
		.modifier(RSEditModifier(hasChanged: hasChanged, loadSessionData: loadSessionData, modifySession: modifySession))
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
