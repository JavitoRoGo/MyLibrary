//
//  OtherStats.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/10/22.
//

import SwiftUI

struct OtherStats: View {
    @EnvironmentObject var model: UserViewModel
    
    let titles = ["Autor", "Editorial", "Encuadernación", "Propietario", "Estado"]
    @State var statsSelection = 0
    @State var pickerSelection = "Elige un valor"
    
    @State var showingPicker = false
    @State var showingGraphs = false
    
    var body: some View {
        ZStack {
            VStack {
                Picker("Categoría", selection: $statsSelection) {
                    ForEach(titles.indices, id:\.self) { index in
                        Text(titles[index])
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                valuePicker
                
                List {
                    pagesSection
                    priceSection
                    thicknessSection
                    weightSection
                }
            }
            
            if showingGraphs {
                OtherGraphs()
            }
        }
        .navigationTitle("Estadísticas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingGraphs.toggle()
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
        }
    }
}

struct OtherStats_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OtherStats()
                .environmentObject(UserViewModel())
        }
    }
}
