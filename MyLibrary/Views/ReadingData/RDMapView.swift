//
//  RDMapView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/3/23.
//

import MapKit
import SwiftUI

struct RDMapView: View {
	@EnvironmentObject var userModel: UserPreferences
	@State private var cameraPosition: MapCameraPosition = .automatic
	@State var mapPins: [MKMapItem] = []
	@State var selectedItem: MKMapItem?
	@State var lookAroundScene: MKLookAroundScene?
	@State var showingMapStyleOptions = false
    
	let books: [ReadingData]
	
	var body: some View {
		ZStack(alignment: .topLeading) {
			Map(position: $cameraPosition, selection: $selectedItem) {
				ForEach(mapPins, id: \.self) { item in
					if books.count == 1 {
						let book = books.first!
						Annotation("", coordinate: CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)) {
							Image(book.cover)
								.resizable()
								.modifier(RDCoverModifier(width: 45, height: 60, cornerRadius: 10, lineWidth: 2))
						}
						.annotationTitles(.hidden)
					} else {
						Marker("Libro", systemImage: "book", coordinate: item.placemark.coordinate)
							.tint(.orange)
							.annotationTitles(.hidden)
					}
				}
			}
			.mapStyle(customMapStyle)
			.navigationTitle(title)
			.navigationBarTitleDisplayMode(.inline)
			.sheet(item: $selectedItem) { item in
				VStack {
					if booksWithLocation.count == 1 {
						itemInfoDetail(item)
					} else {
						itemsInfoDetail(item)
					}
				}
				.padding(.top, 25)
				.presentationCornerRadius(25)
			}
			
			mapStyleButton
		}
		.task {
			if booksWithLocation.count == 1 {
				do {
					try await createPin()
				} catch {
					print("Error al crear el objeto MKMapItem.")
				}
			} else if booksWithLocation.count > 1 {
				createPins()
			}
		}
		.onChange(of: selectedItem) {
			fetchLookAroundPreview()
		}
    }
}

struct RDMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
			RDMapView(books: [ReadingData.dataTest])
				.environmentObject(UserPreferences())
        }
    }
}


// Necesario conformar MKMapItem a Identifiable para usarlo en sheet
extension MKMapItem: Identifiable { }
