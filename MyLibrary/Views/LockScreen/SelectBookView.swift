//
//  SelectBookView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/8/23.
//

import SwiftUI

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
