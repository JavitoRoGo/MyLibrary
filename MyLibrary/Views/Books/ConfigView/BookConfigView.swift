//
//  BookConfigView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/12/22.
//

import SwiftUI

struct BookConfigView: View {
    @State private var showingAddBook = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showingAddBook = true
                    } label: {
                        HStack {
                            Image(systemName: "doc.badge.plus")
                                .foregroundColor(.green)
                            Text("Añadir un nuevo libro")
                                .foregroundColor(.primary)
                            
                        }
                    }
                }
                Section {
                    NavigationLink(destination: EditPlaces()) {
                        HStack {
                            Image(systemName: "rectangle.and.pencil.and.ellipsis")
                                .foregroundColor(.blue)
                            Text("Ubicaciones")
                        }
                    }
                    NavigationLink(destination: ChangeBooksPlace()) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundColor(.blue)
                            Text("Cambio masivo de ubicación")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: EditOwners()) {
                        HStack {
                            Image(systemName: "person.circle")
                                .foregroundColor(.pink)
                            Text("Propietarios")
                        }
                    }
                    NavigationLink(destination: ChangeBooksOwner()) {
                        HStack {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundColor(.pink)
                            Text("Cambio masivo de propietario")
                        }
                    }
                }
            }
            .navigationTitle("Ajustes")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingAddBook) {
                AddBook()
            }
        }
    }
}

struct BookConfigView_Previews: PreviewProvider {
    static var previews: some View {
        BookConfigView()
    }
}
