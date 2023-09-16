//
//  MainBookViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension MainBookView {
    struct MainBookViewModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
        @Binding var showingSold: Bool
        @Binding var showingDonated: Bool
        
        func body(content: Content) -> some View {
            content
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
                .background {
                    Color.secondary.opacity(0.1)
                        .ignoresSafeArea()
                }
                .navigationTitle("Libros")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: BookConfigView()) {
                            Label("Configuración", systemImage: "gearshape")
                        }
                    }
                }
                .sheet(isPresented: $showingSold) {
                    NavigationView {
                        BookList(customPreferredGridView: model.preferredGridView, place: soldText)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Volver") {
                                        showingSold = false
                                    }
                                }
                            }
                    }
                }
                .sheet(isPresented: $showingDonated) {
                    NavigationView {
                        BookList(customPreferredGridView: model.preferredGridView, place: donatedText)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Volver") {
                                        showingDonated = false
                                    }
                                }
                            }
                    }
                }
        }
    }
}
