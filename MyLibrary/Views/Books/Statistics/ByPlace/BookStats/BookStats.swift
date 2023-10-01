//
//  BookStats.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/1/22.
//

// Se mantiene la gráfica inicial y sus estadísticas por ubicación como ejemplo de gráfica pre-SwiftCharts

import SwiftUI

struct BookStats: View {
    @Environment(GlobalViewModel.self) var model
    @State var place: String
    @State var showingPlacePicker = false
    @State var showingGraph = false
    
    var body: some View {
        ZStack {
            VStack {
                placePicker
                
                List {
                    pagesSection
                    priceSection
                    thicknessSection
                    weightSection
                }
            }
            
            if showingGraph {
                GraphView()
            }
        }
        .navigationTitle("Datos por ubicación")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingGraph.toggle()
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
        }
    }
}

struct BookStats_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookStats(place: "A1")
				.environment(GlobalViewModel.preview)
        }
    }
}
