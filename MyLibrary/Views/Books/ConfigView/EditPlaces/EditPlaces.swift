//
//  EditPlaces.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/8/22.
//

import SwiftUI

struct EditPlaces: View {
    @Environment(GlobalViewModel.self) var model
    
    @State var oldPlace = ""
    @State var newPlace = ""
    @State var showingAddPlace = false
    @State var showingEditPlace = false
    @State var showingDeleteAlert = false
    @State var showingEditAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Gestiona aquí las ubicaciones donde colocar los libros")
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)
                List {
                    placesSection
                    Section {
						ForEach(model.userLogic.getSuggestedPlacesFromData(), id:\.self) { place in
                            Button {
								model.userLogic.user.myPlaces.append(place)
                            } label: {
                                Text(place)
                            }
							.disabled(model.userLogic.user.myPlaces.contains(place))
                        }
                    } header: {
                        Text("Sugerencias")
                    } footer: {
                        Text("Se muestran sugerencias de nombres de propietarios basadas en la base de datos de libros. Pulsa sobre un nombre para añadirlo.")
                    }
                }
				.modifier(PlacesListModifier(oldPlace: $oldPlace, newPlace: $newPlace, showingAddPlace: $showingAddPlace, showingEditPlace: $showingEditPlace, showingDeleteAlert: $showingDeleteAlert, showingEditAlert: $showingEditAlert))
            }
            
            if showingAddPlace {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
                VStack {
                    TextField("Introduce el nombre de la nueva ubicación", text: $newPlace)
                        .padding()
                        .textFieldStyle(.roundedBorder)
                    HStack(spacing: 90) {
                        Button("Cancelar", role: .cancel) {
                            newPlace = ""
                            showingAddPlace = false
                        }
                        .buttonStyle(.bordered)
                        Button("Añadir") {
							model.userLogic.user.myPlaces.insert(newPlace, at: 0)
                            newPlace = ""
                            showingAddPlace = false
                        }
                        .buttonStyle(.bordered)
                        .disabled(newPlace.isEmpty)
                    }
                    Spacer()
                }
            }
        }
		.modifier(EditPlacesModifier(showingAddPlace: $showingAddPlace, showingEditPlace: $showingEditPlace))
    }
}

struct EditPlaces_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPlaces()
				.environment(GlobalViewModel.preview)
        }
    }
}
