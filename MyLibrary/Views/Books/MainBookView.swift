//
//  MainBookView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/7/22.
//

import SwiftUI

struct MainBookView: View {
    @EnvironmentObject var model: BooksModel
    
    @State private var showingSold = false
    @State private var showingDonated = false
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    VStack(spacing: 15) {
                        EachMainViewButton(iconImage: "books.vertical", iconColor: .pink, number: model.numAtPlace("all"), title: "Todos", destination: PlaceList())
                        ScrollByPlace()
                        ScrollByStatus()
                        ScrollByOwner(format: .book)
                        Divider()
                    }
                    VStack(spacing: 15) {
                        HStack(spacing: 10) {
                            // Se mantiene la gráfica inicial y sus estadísticas por ubicación como ejemplo de gráfica pre-SwiftCharts
                            EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .mint, number: 0, title: "Por ubicación", destination: BookStats(place: "Por colocar"))
                            EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .mint, number: 0, title: "Otros datos", destination: OtherStats())
                        }
                        Divider()
                    }
                    
                    Button {
                        showingDonated.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Mostrar libros donados (\(model.numAtPlace(donatedText)))")
                                .padding(.vertical)
                            Spacer()
                        }
                        .background {
                            ButtonBackground()
                        }
                    }
                    Button {
                        showingSold.toggle()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Mostrar libros vendidos (\(model.numAtPlace(soldText)))")
                                .padding(.vertical)
                            Spacer()
                        }
                        .background {
                            ButtonBackground()
                        }
                    }
                }
            }
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
                    BookList(place: soldText)
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
                    BookList(place: donatedText)
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

struct MainBookView_Previews: PreviewProvider {
    static var previews: some View {
        MainBookView()
            .environmentObject(BooksModel())
    }
}
