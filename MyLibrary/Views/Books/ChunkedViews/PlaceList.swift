//
//  PlaceList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct PlaceList: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    
    var places: [String] {
		var tempPlaces = model.userLogic.user.myPlaces
        tempPlaces.removeAll(where: { $0 == soldText })
        tempPlaces.removeAll(where: { $0 == donatedText })
        return tempPlaces
    }
    
    var body: some View {
        List() {
			NavigationLink(destination: BookList(customPreferredGridView: preferences.preferredGridView, place: "all")) {
                PlaceRow(place: "all")
            }
            ForEach(places, id: \.self) { place in
				NavigationLink(destination: BookList(customPreferredGridView: preferences.preferredGridView, place: place)) {
                    PlaceRow(place: place)
                }
            }
        }
        .navigationTitle("Ubicación")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PlaceList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlaceList()
				.environment(GlobalViewModel.preview)
				.environmentObject(UserPreferences())
        }
    }
}
