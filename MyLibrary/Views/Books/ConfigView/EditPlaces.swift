//
//  EditPlaces.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/8/22.
//

import SwiftUI

struct EditPlaces: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    
    @State private var oldPlace = ""
    @State private var newPlace = ""
    @State private var showingAddPlace = false
    @State private var showingEditPlace = false
    @State private var showingDeleteAlert = false
    @State private var showingEditAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Text("Gestiona aquí las ubicaciones donde colocar los libros")
                    .font(.title2).bold()
                    .multilineTextAlignment(.center)
                List {
                    Section {
                        ForEach(model.myPlaces, id: \.self) { place in
                            NavigationLink {
                                VStack {
                                    Text("Cambia aquí el nombre de esta ubicación:")
                                    TextField(place, text: $newPlace)
                                        .padding()
                                        .textFieldStyle(.roundedBorder)
                                    Spacer()
                                }
                                .toolbar {
                                    Button("Modificar") {
                                        if let index = model.myPlaces.firstIndex(of: place) {
                                            model.myPlaces[index] = newPlace
                                            if bmodel.numAtPlace(place) != 0 {
                                                oldPlace = place
                                                showingEditAlert = true
                                            }
                                        }
                                    }
                                    .disabled(newPlace.isEmpty || place == soldText || place == donatedText)
                                }
                            } label: {
                                Text(place)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        if bmodel.numAtPlace(place) == 0 {
                                            model.myPlaces.removeAll(where: { $0 == place })
                                        } else {
                                            oldPlace = place
                                            showingDeleteAlert = true
                                        }
                                    }
                                } label: {
                                    Label("Borrar", systemImage: "trash")
                                }
                                .disabled(place == soldText || place == donatedText)
                            }
                        }
                        .onMove(perform: move)
                    } header: {
                        Text("Ubicaciones creadas")
                    } footer: {
                        Text("Se muestran los nombres de las ubicaciones creadas. Pulsa sobre una ubicación para editarla o desliza para borrarla.")
                    }
                    Section {
                        ForEach(bmodel.getSuggestedPlacesFromData(), id:\.self) { place in
                            Button {
                                model.myPlaces.append(place)
                            } label: {
                                Text(place)
                            }
                            .disabled(model.myPlaces.contains(place))
                        }
                    } header: {
                        Text("Sugerencias")
                    } footer: {
                        Text("Se muestran sugerencias de nombres de propietarios basadas en la base de datos de libros. Pulsa sobre un nombre para añadirlo.")
                    }
                }
                .toolbar {
                    EditButton()
                        .disabled(showingAddPlace || showingEditPlace)
                }
                .alert("Esta ubicación tiene libros registrados.\n¿Deseas borrarla de todas formas?", isPresented: $showingDeleteAlert) {
                    Button("No", role: .cancel) { }
                    Button("Sí", role: .destructive) {
                        model.myPlaces.removeAll(where: { $0 == oldPlace })
                        bmodel.moveFromTo(from: oldPlace, to: "sin asignar")
                        oldPlace = ""
                    }
                } message: {
                    Text("Esto NO borrará los libros registrados.")
                }
                .alert("Se ha modificado el nombre de esta ubicación.", isPresented: $showingEditAlert) {
                    Button("No", role: .cancel) { }
                    Button("Sí") {
                        bmodel.moveFromTo(from: oldPlace, to: newPlace)
                        newPlace = ""
                    }
                } message: {
                    Text("¿Quieres cambiar también la ubicación en todos los registros?")
                }
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
                            model.myPlaces.insert(newPlace, at: 0)
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
        .disableAutocorrection(true)
        .navigationTitle("Ubicaciones")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button() {
                    showingAddPlace = true
                } label: {
                    Label("Añadir", systemImage: "plus")
                }
                .disabled(showingAddPlace || showingEditPlace)
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        model.myPlaces.move(fromOffsets: source, toOffset: destination)
    }
}

struct EditPlaces_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPlaces()
                .environmentObject(UserViewModel())
                .environmentObject(BooksModel())
        }
    }
}
