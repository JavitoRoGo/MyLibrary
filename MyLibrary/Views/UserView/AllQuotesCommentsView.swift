//
//  AllQuotesCommentsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/1/23.
//

import SwiftUI

struct AllQuotesCommentsView: View {
    @EnvironmentObject var model: UserViewModel
    @State private var showingQuotes = true
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if showingQuotes {
                    if model.allQuotes.isEmpty {
                        Text("Todavía no has añadido ninguna cita. Inicia una sesión de lectura y pulsa sobre el icono \(Image(systemName: "quote.bubble")) para agregar una.")
                            .padding(.horizontal)
                    } else {
                        List {
                            Section("\(model.allQuotes.count) citas") {
                                ForEach(model.allQuotes, id:\.date) { quote in
                                    VStack(alignment: .leading) {
                                        Text("Recogida el \(quote.date.formatted(date: .numeric, time: .omitted)) en la página \(quote.page) de \(quote.bookTitle).")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(quote.text)
                                            .bold()
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            showingAlert = true
                                        } label: {
                                            Image(systemName: "trash.slash")
                                        }
                                        .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    if model.allComments.isEmpty {
                        Text("Todavía no has añadido ningún comentario. Termina una sesión de lectura para agregar uno.")
                            .padding(.horizontal)
                    } else {
                        List {
                            Section("\(model.allComments.count) comentarios") {
                                ForEach(model.allComments, id:\.date) { comment in
                                    VStack(alignment: .leading) {
                                        Text("Recogido el \(comment.date.formatted(date: .numeric, time: .omitted)) del libro \(comment.bookTitle).")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(comment.text)
                                            .bold()
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            showingAlert = true
                                        } label: {
                                            Image(systemName: "trash.slash")
                                        }
                                        .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(showingQuotes ? "Citas" : "Comentarios") de sesiones")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingQuotes.toggle()
                    } label: {
                        Text(showingQuotes ? "Comentarios" : "Citas")
                    }
                }
            }
            .alert("No puedes borrar desde aquí.", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("Para borrar esta entrada debes dirigirte a la sesión correspondiente y eliminarla ahí.")
            }
        }
    }
}

struct AllQuotesCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        AllQuotesCommentsView()
            .environmentObject(UserViewModel())
    }
}
