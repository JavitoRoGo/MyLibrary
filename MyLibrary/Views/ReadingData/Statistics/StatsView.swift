//
//  StatsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/4/22.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var model: RDModel
    @State var graphKey = "Libros leídos por año"
    @State var tag = 0
    
    var body: some View {
        let colors = model.getColors()
        VStack {
            HStack {
                Text(graphKey)
                Spacer()
                RoundedGraphMenu(graphKey: $graphKey, tag: $tag)
            }
            RingCircleArc(datas: model.datas(tag: tag).1, colors: colors)
            StatsList(tag: tag, colors: colors)
            Spacer()
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
                .environmentObject(RDModel())
        }
    }
}
