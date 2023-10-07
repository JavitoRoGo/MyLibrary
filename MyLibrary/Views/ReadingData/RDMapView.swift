//
//  RDMapView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/3/23.
//

import MapKit
import SwiftUI

struct RDMapView: View {
	@State private var cameraPosition: MapCameraPosition = .automatic
	@State var mapPins: [MKMapItem] = []
	@State var selectedItem: MKMapItem?
	@State var lookAroundScene: MKLookAroundScene?
    
	let books: [ReadingData]
	
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
    
    var body: some View {
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
        }
    }
}


// Necesario conformar MKMapItem a Identifiable para usarlo en sheet
extension MKMapItem: Identifiable { }
