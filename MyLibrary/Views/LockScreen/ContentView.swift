//
//  ContentView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: UserViewModel
    @Binding var isUnlocked: Bool
    
    var body: some View {
        TabView {
            ActualReading()
                .tabItem {
                    Label("Leyendo", systemImage: "stopwatch")
                }
            
            DynamicStatsView()
                .badge(Double(model.user.sessions.count).stringFormat)
                .tabItem {
                    Label("Sesiones", systemImage: "calendar")
                }
            
            RDMain()
                .tabItem {
                    Label("Registros", systemImage: "textformat.abc")
                }
            
            SelectBookView() // ver struct más abajo
                .tabItem {
                    Label("Libros/eBooks", systemImage: "book")
                }
            
            UserMainView(isUnlocked: $isUnlocked)
                .tabItem {
                    Label("Usuario", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isUnlocked: .constant(true))
            .environmentObject(UserViewModel())
    }
}

struct SelectBookView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: MainBookView()) {
                        HStack {
                            Image(systemName: "books.vertical")
                                .foregroundColor(.green)
                            Text("Libros en papel")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: EBookMainView()) {
                        HStack {
                            Image(systemName: "book.circle")
                                .foregroundColor(.pink)
                            Text("eBooks")
                        }
                    }
                }
            }
            .navigationTitle("Libros / eBooks")
        }
    }
}
