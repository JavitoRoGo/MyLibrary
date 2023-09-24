//
//  DynamicStatsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 7/6/22.
//

import SwiftUI

struct DynamicStatsView: View {
	@Environment(GlobalViewModel.self) var model
	
    let titles = ["SwiwftCharts", "Clásica"]
    @State private var graphSelection = 0
    let titles2 = ["Semana", "Mes", "Año", "Total"]
    @State private var timeIntervalSelection = 0
    
    var body: some View {
        NavigationView {
			if !model.userLogic.user.sessions.isEmpty {
				VStack {
					VStack {
						Picker("Tipo de gráfica", selection: $graphSelection.animation()) {
							ForEach(titles.indices, id:\.self) { index in
								Text(titles[index])
							}
						}
						Picker("Intervalo de tiempo", selection: $timeIntervalSelection) {
							ForEach(titles2.indices, id:\.self) { index in
								Text(titles2[index])
							}
						}
					}
					.pickerStyle(.segmented)
					.padding()
					
					if graphSelection == 0 {
						StatsLineSwiftChart(graphSelection: timeIntervalSelection)
							.padding(.horizontal)
					} else if graphSelection == 1 {
						DynamicStatsLineChart(graphSelected: timeIntervalSelection)
					}
					
					DynamicStatsList(graphSelected: timeIntervalSelection)
				}
				.navigationTitle("Sesiones de lectura")
				.navigationBarTitleDisplayMode(.inline)
			} else {
				Text("Completa tu primera sesión de lectura para ver aquí los datos.")
					.multilineTextAlignment(.center)
					.bold()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background {
						Image("mockRSView")
							.resizable()
							.scaledToFit()
							.opacity(0.2)
					}
					.navigationTitle("Sesiones de lectura")
					.navigationBarTitleDisplayMode(.inline)
			}
        }
    }
}

struct DynamicStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicStatsView()
			.environment(GlobalViewModel.preview)
    }
}
