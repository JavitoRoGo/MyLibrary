//
//  RDStatsMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/12/22.
//

import SwiftUI

struct RDStatsMainView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: StatsView()) {
                        HStack {
                            Image(systemName: "chart.pie.fill")
                                .foregroundColor(.mint)
                            Text("Por año, tipo y valoración")
                        }
                    }
                    NavigationLink(destination: LineChart()) {
                        HStack {
                            Image(systemName: "chart.xyaxis.line")
                                .foregroundColor(.blue)
                            Text("Evolución pág/día")
                        }
                    }
                    NavigationLink(destination: MaxAndMin()) {
                        HStack {
                            Image(systemName: "chart.bar.xaxis")
                                .foregroundColor(.red)
                            Text("Máximos y mínimos por libro")
                        }
                    }
                }
                Section {
                    NavigationLink(destination: RDGlobalStats()) {
                        HStack {
                            Image(systemName: "rectangle.grid.1x2")
                                .foregroundColor(.blue)
                            Text("Desglose de datos por formato")
                        }
                    }
                }
            }
            .navigationTitle("Estadísticas")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RDStatsMainView_Previews: PreviewProvider {
    static var previews: some View {
        RDStatsMainView()
    }
}
