//
//  PlacePickerExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

// Subvistas y secciones que componen la vista
extension BookStats {
	var placePicker: some View {
		VStack {
			Text("Pulsa para elegir una ubicación")
				.font(.footnote)
			ZStack {
				Button {
					withAnimation {
						showingPlacePicker = true
					}
				} label: {
					Text(place == "all" ? "Todos" : place)
						.font(.largeTitle)
						.foregroundColor(.primary)
						.frame(width: 200, height: 55)
						.background(.tertiary)
						.cornerRadius(20)
						.shadow(color: .black, radius: 7)
				}
				.zIndex(1)
				if showingPlacePicker {
					VStack {
						HStack {
							Spacer()
							Button("Listo") {
								withAnimation {
									showingPlacePicker = false
								}
							}
							.padding()
						}
						Picker("Ubicación", selection: $place) {
							ForEach(model.userLogic.user.myPlaces, id: \.self) {
								Text($0)
							}
						}
						.pickerStyle(.wheel)
					}
					.background(Color(UIColor.systemGray2))
					.opacity(1)
					.zIndex(2)
					.transition(.opacity)
				}
			}
			HStack {
				Spacer()
				Text("Libros:")
					.font(.title3)
				Spacer()
				Text(String(model.userLogic.numberOfBooksAtPlace(place)))
					.font(.largeTitle)
					.frame(width: 75, height: 55)
					.background(model.userLogic.numColor(model.userLogic.numberOfBooksAtPlace(place)))
					.cornerRadius(15)
					.overlay {
						RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 2)
					}
					.shadow(color: .black, radius: 5)
				Spacer()
			}
			.padding(.top, 30)
		}
		.padding(.top, 10)
	}
}
