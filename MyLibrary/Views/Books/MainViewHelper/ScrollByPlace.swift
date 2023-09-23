//
//  ScrollByPlace.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct ScrollByPlace: View {
    @EnvironmentObject var model: GlobalViewModel
    @State private var showingAddPlace = false
    
    var places: [String] {
		var tempPlaces = model.userLogic.user.myPlaces
        tempPlaces.removeAll(where: { $0 == soldText })
        tempPlaces.removeAll(where: { $0 == donatedText })
        return tempPlaces
    }
    
    var body: some View {
        if !places.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 5) {
                    ForEach(places, id: \.self) { place in
						NavigationLink(destination: BookList(customPreferredGridView: model.userLogic.preferredGridView, place: place)) {
                            VStack {
                                Text(place)
                                    .font(.title3.bold())
								Text("\(model.userLogic.numberOfBooksAtPlace(place)) libros")
                                    .font(.caption)
                            }
                        }
                        .padding()
                        .background {
                            ButtonBackground()
                        }
                    }
                }
            }
        } else {
            VStack {
                Text("No existe ninguna ubicación. Pulsa para crear una nueva.")
                Button("Crear ubicación") {
                    showingAddPlace.toggle()
                }
                .foregroundColor(.blue)
                .buttonStyle(.bordered)
            }
            .padding()
            .background(ButtonBackground())
            .sheet(isPresented: $showingAddPlace) {
                NavigationStack {
                    EditPlaces()
                }
            }
        }
    }
}

struct ScrollByPlace_Previews: PreviewProvider {
    static var previews: some View {
        ScrollByPlace()
			.environmentObject(GlobalViewModel.preview)
    }
}
