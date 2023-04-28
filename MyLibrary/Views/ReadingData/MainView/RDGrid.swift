//
//  RDGrid.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/22.
//

import SwiftUI

struct RDGrid: View {
    @EnvironmentObject var model: RDModel
    @State private var searchText = ""
    
    let columns = [GridItem(.adaptive(minimum: 120))]
    let filterByRatingSelection: FilterByRating
    
    var filteredRD: [ReadingData] {
        if filterByRatingSelection == .all {
            return model.readingDatas.reversed()
        } else {
            return model.readingDatas.filter { $0.rating == filterByRatingSelection.rawValue }.reversed()
        }
    }
    var searchRD: [ReadingData] {
        if searchText.isEmpty {
            return filteredRD
        } else {
            return filteredRD.filter { $0.bookTitle.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(searchRD) { rdata in
                    NavigationLink(destination: RDDetail(rdata: rdata)) {
                        RDCell(rdata: rdata)
                    }
                }
            }
        }
        .navigationTitle("Lecturas")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Búsqueda por título")
        .disableAutocorrection(true)
    }
}

struct RDGrid_Previews: PreviewProvider {
    static var previews: some View {
        RDGrid(filterByRatingSelection: .all)
            .environmentObject(RDModel())
    }
}
