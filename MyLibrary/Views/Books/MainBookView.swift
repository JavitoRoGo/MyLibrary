//
//  MainBookView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/7/22.
//

import SwiftUI

struct MainBookView: View {
    @Environment(GlobalViewModel.self) var model
    
    @State var showingSold = false
    @State var showingDonated = false
	
	var areStatsDisabled: Bool {
		model.userLogic.user.books.isEmpty
	}
        
    var body: some View {
        NavigationStack {
            ScrollView {
                    VStack(spacing: 15) {
						EachMainViewButton(iconImage: "books.vertical", iconColor: .pink, number: model.userLogic.numberOfBooksAtPlace("all"), title: "Todos", destination: ChunkedMenuView())
                        ScrollByStatus()
                        ScrollByOwner(format: .book)
                        Divider()
                    }
                    VStack(spacing: 15) {
                        HStack(spacing: 10) {
                            // Se mantiene la gráfica inicial y sus estadísticas por ubicación como ejemplo de gráfica pre-SwiftCharts
                            EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .mint, number: 0, title: "Por ubicación", destination: BookStats(place: "Por colocar"))
								.disabled(areStatsDisabled)
								.foregroundColor(areStatsDisabled ? .secondary.opacity(0.2) : .primary)
                            EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .mint, number: 0, title: "Otros datos", destination: OtherStats())
								.disabled(areStatsDisabled)
								.foregroundColor(areStatsDisabled ? .secondary.opacity(0.2) : .primary)
                        }
                        Divider()
                    }
                    
                    Button {
                        showingDonated.toggle()
                    } label: {
                        HStack {
                            Spacer()
							Text("Mostrar libros donados (\(model.userLogic.numberOfBooksAtPlace(donatedText)))")
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
							Text("Mostrar libros vendidos (\(model.userLogic.numberOfBooksAtPlace(soldText)))")
                                .padding(.vertical)
                            Spacer()
                        }
                        .background {
                            ButtonBackground()
                        }
                    }
            }
			.scrollIndicators(.hidden)
            .modifier(MainBookViewModifier(showingSold: $showingSold, showingDonated: $showingDonated))
        }
    }
}

struct MainBookView_Previews: PreviewProvider {
    static var previews: some View {
        MainBookView()
			.environment(GlobalViewModel.preview)
    }
}
