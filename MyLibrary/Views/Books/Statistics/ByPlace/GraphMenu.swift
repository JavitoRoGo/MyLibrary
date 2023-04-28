//
//  GraphMenu.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/4/22.
//

import SwiftUI

struct GraphMenu: View {
    @Binding var graphKey: String
    @Binding var tag: Int
    
    var body: some View {
        Menu {
            Button("Libros") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Número de libros"
                    tag = 0
                }
            }
            Button("Páginas") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Número de páginas"
                    tag = 1
                }
            }
            Button("Precio") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Precio, €"
                    tag = 2
                }
            }
            Button("Grosor") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Grosor, cm"
                    tag = 3
                }
            }
            Button("Peso") {
                withAnimation(.linear(duration: 1.2)) {
                    graphKey = "Peso, g"
                    tag = 4
                }
            }
        } label: {
            Text("Mostrar")
        }
    }
}

struct GraphMenu_Previews: PreviewProvider {
    static var previews: some View {
        GraphMenu(graphKey: .constant("Libros"), tag: .constant(0))
    }
}
