//
//  RDMain.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/22.
//

import SwiftUI

struct RDMain: View {
    @EnvironmentObject var model: GlobalViewModel
    
    @State private var rating: Int = 1
    
    var filter: FilterByRating {
        switch rating {
        case 1: return .star1
        case 2: return .star2
        case 3: return .star3
        case 4: return .star4
        case 5: return .star5
        default: return .all
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
				if !model.userLogic.user.readingDatas.isEmpty {
					VStack(spacing: 15) {
						HStack(spacing: 10) {
							EachMainViewButton(iconImage: "list.star", iconColor: .pink, number: model.userLogic.user.readingDatas.count, title: "Lista", destination: RDList())
							EachMainViewButton(iconImage: "square.grid.3x3", iconColor: .pink, number: model.userLogic.user.readingDatas.count, title: "Mosaico", destination: RDGrid(filterByRatingSelection: .all))
						}
						ScrollView(.horizontal) {
							HStack(spacing: 5) {
								ForEach(model.userLogic.user.bookFinishingYears.reversed(), id: \.self) { year in
									NavigationLink(destination: RDList(year: year)) {
										VStack {
											Text(String(year))
												.font(.title3.bold())
											Text("\(model.userLogic.numberOfReadingDataPerYear(year, filterBy: .all)) libros")
												.font(.caption)
										}
									}
									.padding()
									.background {
										ButtonBackground()
									}
								}
							}
						}
						NavigationLink(destination: RDGrid(filterByRatingSelection: filter)) {
							VStack(alignment: .leading) {
								HStack {
									RDStars(rating: $rating)
										.font(.title)
									Spacer()
									Text(model.userLogic.numberOfReadingDataPerStar(rating), format: .number)
										.font(.title2.bold())
								}
								Text("Toca las estrellas para ver el total")
									.font(.caption)
									.foregroundColor(.secondary)
									.padding(.top, 5)
							}
						}
						.padding()
						.background {
							ButtonBackground()
						}
						VStack {
							Divider()
							EachMainViewButton(iconImage: "chart.pie.fill", iconColor: .mint, number: 0, title: "Estadísticas", destination: RDStatsMainView())
							EachMainViewButton(iconImage: "map.fill", iconColor: .blue, number: 0, title: "Ubicaciones", destination: RDMapView(pins: model.userLogic.rdlocations))
							Spacer()
						}
					}
                } else {
					Text("Completa tu primera lectura para ver aquí los datos.")
						.bold()
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background {
							Image("mockRDView")
								.resizable()
								.scaledToFit()
								.opacity(0.2)
						}
                }
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 20)
            .background {
                Color.secondary.opacity(0.1)
                    .ignoresSafeArea()
            }
            .navigationTitle("Lecturas")
        }
    }
}

struct RDMain_Previews: PreviewProvider {
    static var previews: some View {
        RDMain()
			.environmentObject(GlobalViewModel.preview)
    }
}
