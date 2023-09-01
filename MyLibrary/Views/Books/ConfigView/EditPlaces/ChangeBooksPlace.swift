//
//  MovingBooks.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/12/22.
//

import SwiftUI

struct ChangeBooksPlace: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert = false
    @State private var oldPlace = ""
    @State private var newPlace = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Selecciona la ubicación de origen y destino para mover todos los libros en bloque:")
                    .padding()
                    .multilineTextAlignment(.center)
                VStack {
                    Picker("Origen", selection: $oldPlace) {
						ForEach(model.user.myPlaces, id: \.self) {
                            Text($0)
                        }
                    }
                    Image(systemName: "arrow.down")
                        .font(.system(size: 50))
                    Picker("Destino", selection: $newPlace) {
						ForEach(model.user.myPlaces, id: \.self) {
                            Text($0)
                        }
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Cambio masivo de ubicación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mover") {
                        showingAlert.toggle()
                    }
                    .disabled(oldPlace == newPlace || oldPlace.isEmpty || newPlace.isEmpty)
                }
            }
            .alert("Esto cambiará la ubicación de \(model.numberOfBooksAtPlace(oldPlace)) libros, de \(oldPlace) a \(newPlace).", isPresented: $showingAlert) {
                Button("No", role: .cancel) { }
                Button("Sí") {
                    model.moveFromTo(from: oldPlace, to: newPlace)
                    dismiss()
                }
            } message: {
                Text("¿Estás seguro?")
            }
        }
    }
}

struct MovingBooks_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ChangeBooksPlace()
                .environmentObject(UserViewModel())
        }
    }
}
