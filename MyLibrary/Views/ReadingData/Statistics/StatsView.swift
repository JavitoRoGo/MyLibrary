//
//  StatsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/4/22.
//

import SwiftUI

struct StatsView: View {
    @Environment(GlobalViewModel.self) var model
    @State var graphKey = "Libros leídos por año"
    @State var tag = 0
    
    var body: some View {
		let datas: [SectorChartData] = model.userLogic.datas(tag: tag)
        VStack {
            HStack {
                Text(graphKey)
                Spacer()
                RoundedGraphMenu(graphKey: $graphKey, tag: $tag)
            }
			if !datas.isEmpty {
				RingCircleArc(sectorChartDatas: datas, tag: tag)
				StatsList(datas: datas, tag: tag)
			} else {
				ContentUnavailableView("No hay datos", systemImage: "book", description: Text("Registra tu primer libro para ver aquí los datos."))
			}
        }
        .padding(.horizontal)
        .navigationTitle("Estadísticas")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            StatsView()
				.environment(GlobalViewModel.preview)
        }
    }
}
