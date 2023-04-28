//
//  RoundedGraphMenu.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/4/22.
//

import SwiftUI

struct RoundedGraphMenu: View {
    @Binding var graphKey: String
    @Binding var tag: Int
    
    var body: some View {
        Menu {
            Button("Libros") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Libros leídos por año"
                    tag = 0
                }
            }
            Button("Páginas") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Páginas leídas por año"
                    tag = 1
                }
            }
            Button("pág/día") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "pág/día por año"
                    tag = 2
                }
            }
            Button("Formato") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Libros leídos por formato"
                    tag = 3
                }
            }
            Button("Valoración") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Libros leídos por valoración"
                    tag = 4
                }
            }
        } label: {
            Text("Mostrar")
        }
    }
}

struct RoundedGraphMenu_Previews: PreviewProvider {
    static var previews: some View {
        RoundedGraphMenu(graphKey: .constant("Libros leídos por año"), tag: .constant(0))
    }
}
