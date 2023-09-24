//
//  AddQuoteView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/1/23.
//

import SwiftUI

struct AddQuoteView: View {
    @Environment(GlobalViewModel.self) var model
    @Environment(\.dismiss) var dismiss
    
    let bookTitle: String
    @State var date: Date = .now
    @State var page = 0
    @State var text = ""
    
    @State var showingSavingAlert = false
    
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
			.modifier(AddQuoteModifier(bookTitle: bookTitle, date: date, page: page, text: text))
        }
    }
}

struct AddQuoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuoteView(bookTitle: "Título del libro")
			.environment(GlobalViewModel.preview)
    }
}
