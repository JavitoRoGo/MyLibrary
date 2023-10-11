//
//  EditRDMapView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 22/3/23.
//

import MapKit
import SwiftUI

struct EditRDMapView: View {
	@EnvironmentObject var userModel: UserPreferences
	@StateObject var manager = LocationManager()
    @Environment(\.dismiss) var dismiss
	
	@State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
	@State var visibleRegion: MKCoordinateRegion?
	@State var myMarkerCoordinate: CLLocationCoordinate2D?
	@State var showingMapStyleOptions = false
    
    @Binding var location: RDLocation?
    
	var body: some View {
		ZStack(alignment: .topLeading) {
			Map(position: $cameraPosition) {
				UserAnnotation()
				if let myMarkerCoordinate {
					Marker("MyMarker", systemImage: "book", coordinate: myMarkerCoordinate)
						.tint(.orange)
						.annotationTitles(.hidden)
				}
			}
			.mapControls {
				MapUserLocationButton()
				MapCompass()
			}
			.mapStyle(customMapStyle)
			.onMapCameraChange { context in
				visibleRegion = context.region
			}
			.safeAreaInset(edge: .bottom, alignment: .center) {
				locationButtons
			}
			
			mapStyleButton
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
			.environmentObject(UserPreferences())
			.environmentObject(LocationManager())
    }
}
