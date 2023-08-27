//
//  MainBookView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/7/22.
//

import SwiftUI

struct MainBookView: View {
    @EnvironmentObject var model: UserViewModel
    
    @State var showingSold = false
    @State var showingDonated = false
        
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    VStack(spacing: 15) {
                        EachMainViewButton(iconImage: "books.vertical", iconColor: .pink, number: model.numberOfBooksAtPlace("all"), title: "Todos", destination: PlaceList())
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
                            Text("Mostrar libros donados (\(model.numberOfBooksAtPlace(donatedText)))")
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
                            Text("Mostrar libros vendidos (\(model.numberOfBooksAtPlace(soldText)))")
                                .padding(.vertical)
                            Spacer()
                        }
                        .background {
                            ButtonBackground()
                        }
                    }
                }
            }
            .modifier(MainBookViewModifier(showingSold: $showingSold, showingDonated: $showingDonated))
        }
    }
}

struct MainBookView_Previews: PreviewProvider {
    static var previews: some View {
        MainBookView()
            .environmentObject(UserViewModel())
    }
}
