//
//  EBookConfigView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/1/23.
//

import SwiftUI

struct EBookConfigView: View {
    @State private var showingAddEBook = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        showingAddEBook = true
                    } label: {
                        HStack {
                            Image(systemName: "doc.badge.plus")
                                .foregroundColor(.green)
                            Text("Añadir un nuevo ebook")
                                .foregroundColor(.primary)
                            
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
            .sheet(isPresented: $showingAddEBook) {
                AddEBook()
            }
        }
    }
}

struct EBookConfigView_Previews: PreviewProvider {
    static var previews: some View {
        EBookConfigView()
    }
}
