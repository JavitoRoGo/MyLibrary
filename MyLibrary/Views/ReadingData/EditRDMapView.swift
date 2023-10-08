//
//  EditRDMapView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 22/3/23.
//

import MapKit
import SwiftUI

struct EditRDMapView: View {
	@StateObject private var manager = LocationManager()
    @Environment(\.dismiss) var dismiss
	
	@State var visibleRegion: MKCoordinateRegion?
    
    @State private var pins = [RDLocation]()
    @Binding var location: RDLocation?
    
	var body: some View {
		VStack {
			Map {
				UserAnnotation()
			}
			.mapControls {
				MapUserLocationButton()
				MapCompass()
			}
			.onMapCameraChange { context in
				visibleRegion = context.region
			}
			.safeAreaInset(edge: .bottom, alignment: .center) {
				VStack {
					Button {
						let userLocation = manager.userLocation
						location = RDLocation(id: UUID(), latitude: userLocation.latitude, longitude: userLocation.longitude)
						dismiss()
					} label: {
						Text("Mi ubicación")
							.frame(width: 250)
					}
					.disabled(!manager.userPermission)
					Button {
						#warning("Implementar crear un marker")
					} label: {
						Text("Marcador")
							.frame(width: 250)
					}
					Text("Puedes elegir entre tu ubicación actual o cualquier otra ubicación en el mapa.")
						.font(.caption)
						.foregroundColor(.secondary)
						.padding(.horizontal)
				}
				.buttonStyle(.borderedProminent)
				.padding(.top)
				.overlay(alignment: .topTrailing) {
					Button {
						dismiss()
					} label: {
						Image(systemName: "xmark.circle.fill")
							.font(.title3)
							.foregroundStyle(.secondary)
					}
					.buttonStyle(.plain)
				}
				.frame(maxWidth: .infinity)
				.background(.ultraThinMaterial)
			}
		}
		.onAppear { manager.checkIfLocationServicesIsEnabled() }
		.alert(manager.locationAlertTitle, isPresented: $manager.showLocationAlert) {
			Button("OK", role: .cancel) { }
		} message: {
			Text(manager.locationAlertMessage)
		}
	}
}

struct EditRDMapView_Previews: PreviewProvider {
    static var previews: some View {
        EditRDMapView(location: .constant(RDLocation(id: UUID(), latitude: 20, longitude: 20)))
			.environmentObject(LocationManager())
    }
}
