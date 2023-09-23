//
//  EbookStatsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/1/23.
//

import SwiftUI

struct EbookStatsView: View {
    @EnvironmentObject var model: GlobalViewModel
    
    let titles = ["Autor", "Propietario", "Estado"]
    @State var statsSelection = 0
    @State var pickerSelection = "Elige un valor"
    
    @State var showingPicker = false
    @State var showingGraphs = false
    
    var body: some View {
        ZStack {
            VStack {
				valuePicker
                
                List {
                    pagesSection
					
                    priceSection
                }
            }
            
            if showingGraphs {
                EBooksStatsChartView()
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

struct EbookStatsView_Previews: PreviewProvider {
    static var previews: some View {
        EbookStatsView()
			.environmentObject(GlobalViewModel.preview)
    }
}
