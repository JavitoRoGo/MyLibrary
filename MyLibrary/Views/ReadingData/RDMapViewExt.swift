//
//  RDMapViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 6/10/23.
//

import MapKit
import SwiftUI

extension RDMapView {
	var booksWithLocation: [ReadingData] {
		books.filter { $0.location != nil }
	}
	
	var title: String {
		if mapPins.isEmpty {
			return "0 libros"
		} else if mapPins.count == 1 {
			return books.first!.bookTitle
		} else {
			return "\(mapPins.count) libros"
		}
	}
	
	var customMapStyle: MapStyle {
		if userModel.preferredStandardMapStyle {
			return .standard(elevation: .realistic)
		} else {
			return .imagery(elevation: .realistic)
		}
	}
	
	@ViewBuilder
	func itemInfoDetail(_ item: MKMapItem) -> some View {
		ScrollView {
			VStack(alignment: .leading) {
				if let index = mapPins.firstIndex(of: item) {
					let book = booksWithLocation[index]
					HStack {
						Image(book.cover)
							.resizable()
							.modifier(RDCoverModifier(width: 100, height: 120, cornerRadius: 15, lineWidth: 3))
						VStack(alignment: .leading) {
							Text(book.bookTitle)
								.font(.title3.bold())
							Text("\(book.startDate.formatted(date: .numeric, time: .omitted)) - \(book.finishDate.formatted(date: .numeric, time: .omitted))")
								.font(.caption)
							RDStars(rating: .constant(book.rating))
							Spacer()
						}
						.padding(.leading)
						Spacer()
					}
					
					Text("Leído en:")
						.font(.caption)
						.padding(.top)
				}
				Text(item.name ?? "Dirección desconocida")
				if lookAroundScene == nil {
					ContentUnavailableView("Vista no disponible", systemImage: "eye.slash")
						.frame(height: 200)
						.clipShape(.rect(cornerRadius: 15))
				} else {
					LookAroundPreview(scene: $lookAroundScene)
						.frame(height: 200)
						.clipShape(.rect(cornerRadius: 15))
				}
				Spacer()
			}
			.padding()
		}
		.presentationDetents([.height(200), .medium])
		.presentationBackgroundInteraction(.enabled)
    }
	
	@ViewBuilder
	func itemsInfoDetail(_ item: MKMapItem) -> some View {
		VStack(alignment: .leading) {
			if let index = mapPins.firstIndex(of: item) {
				let book = booksWithLocation[index]
				HStack {
					Image(book.cover)
						.resizable()
						.modifier(RDCoverModifier(width: 100, height: 120, cornerRadius: 15, lineWidth: 3))
					VStack(alignment: .leading) {
						Text(book.bookTitle)
							.font(.title3.bold())
						Text("\(book.startDate.formatted(date: .numeric, time: .omitted)) - \(book.finishDate.formatted(date: .numeric, time: .omitted))")
							.font(.caption)
						RDStars(rating: .constant(book.rating))
						Spacer()
					}
					.padding(.leading)
					Spacer()
				}
			}
			
			Spacer()
		}
		.padding()
		.presentationDetents([.height(200)])
	}
	
	var mapStyleButton: some View {
		HStack {
			Button {
				withAnimation(.spring) {
					showingMapStyleOptions.toggle()
				}
			} label: {
				Image(systemName: "map")
					.font(.title3)
					.foregroundStyle(.white)
					.padding(12)
					.background(.green)
					.clipShape(.circle)
			}
			if showingMapStyleOptions {
				Button {
					withAnimation(.easeInOut) {
						userModel.preferredStandardMapStyle = true
						showingMapStyleOptions.toggle()
					}
				} label: {
					Text("Por defecto")
						.font(.caption)
						.foregroundStyle(.white)
						.padding(7)
						.background(.gray)
						.clipShape(.rect(cornerRadius: 12))
				}
				Button {
					withAnimation(.easeInOut) {
						userModel.preferredStandardMapStyle = false
						showingMapStyleOptions.toggle()
					}
				} label: {
					Text("Satélite")
						.font(.caption)
						.foregroundStyle(.white)
						.padding(7)
						.background(.gray)
						.clipShape(.rect(cornerRadius: 12))
				}
			}
		}
		.buttonStyle(.plain)
		.offset(x: 20, y: 15)
	}
	
	func createPin() async throws {
		for book in booksWithLocation {
			let newLocation = CLLocation(latitude: book.location!.latitude, longitude: book.location!.longitude)
			if let newPlace = try await CLGeocoder().reverseGeocodeLocation(newLocation).first {
				let newMarker = MKMapItem(placemark: MKPlacemark(placemark: newPlace))
				mapPins.append(newMarker)
			}
		}
	}
	
	func createPins() {
		booksWithLocation.forEach { book in
			let newItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: book.location!.latitude, longitude: book.location!.longitude)))
			mapPins.append(newItem)
		}
	}
	
	func fetchLookAroundPreview() {
		if let selectedItem {
			// Clearing old one
			lookAroundScene = nil
			Task {
				let request = MKLookAroundSceneRequest(mapItem: selectedItem)
				lookAroundScene = try? await request.scene
			}
		}
	}
}
