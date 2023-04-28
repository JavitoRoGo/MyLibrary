//
//  AddQuoteView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/1/23.
//

import SwiftUI

struct AddQuoteView: View {
    @EnvironmentObject var model: ReadingSessionModel
    @Environment(\.dismiss) var dismiss
    
    let bookTitle: String
    @State private var date: Date = .now
    @State private var page = 0
    @State private var text = ""
    
    @State private var showingSavingAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Fecha de creación de la cita", selection: $date, in: ...Date())
                }
                Section {
                    HStack {
                        Text("Página de la cita")
                        Spacer()
                        TextField("página", value: $page, format: .number)
                            .multilineTextAlignment(.trailing)
                            .labelsHidden()
                    }
                    .keyboardType(.numberPad)
                }
                Section("Cita:") {
                    TextEditor(text: $text)
                        .frame(height: 200)
                }
            }
            .navigationTitle("Crear cita")
            .navigationBarTitleDisplayMode(.inline)
            .autocorrectionDisabled(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Crear") {
                        let newQuote = Quote(date: date, bookTitle: bookTitle, page: page, text: text)
                        model.tempQuotesArray.insert(newQuote, at: 0)
                        showingSavingAlert = true
                    }
                    .disabled(page == 0 || text.isEmpty)
                }
            }
            .alert("La cita se ha creado correctamente.", isPresented: $showingSavingAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Podrás ver todas las citas creadas al finalizar la sesión actual de lectura.")
            }
        }
    }
}

struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView(bookTitle: "Título del libro")
            .environmentObject(ReadingSessionModel())
    }
}
