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
            
            SelectBookView()
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
