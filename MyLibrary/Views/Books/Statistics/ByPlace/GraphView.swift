//
//  GraphView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/4/22.
//

import SwiftUI

struct GraphView: View {
    @State private var graphKey = "Número de libros"
    @State private var tag = 0
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                HStack {
                    Capsule()
                        .fill(.blue)
                        .frame(width: 20, height: 8)
                    Text(graphKey)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                GraphMenu(graphKey: $graphKey, tag: $tag)
            }
            ScrollView {
                HBarGraph(tag: tag)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
            .environmentObject(BooksModel())
    }
}
