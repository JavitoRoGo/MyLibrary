//
//  PlaceList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct PlaceList: View {
    @EnvironmentObject var model: UserViewModel
    
    var places: [String] {
        var tempPlaces = model.myPlaces
        tempPlaces.removeAll(where: { $0 == soldText })
        tempPlaces.removeAll(where: { $0 == donatedText })
        return tempPlaces
    }
    
    var body: some View {
        List() {
            NavigationLink(destination: BookList(place: "all")) {
                PlaceRow(place: "all")
            }
            ForEach(places, id: \.self) { place in
                NavigationLink(destination: BookList(place: place)) {
                    PlaceRow(place: place)
                }
            }
        }
        .navigationTitle("Libros")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceList()
                .environmentObject(UserViewModel())
        }
    }
}
