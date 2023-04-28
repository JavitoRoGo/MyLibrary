//
//  RDMapView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/3/23.
//

import MapKit
import SwiftUI

struct RDMapView: View {
    @EnvironmentObject var manager: LocationManager
    @State private var region = MKCoordinateRegion()
    
    let pins: [RDLocation]
    
    var title: String {
        if pins.isEmpty {
            return "0 libros"
        } else {
            return "\(pins.count) libro\(pins.count > 1 ? "s" : "")"
        }
    }
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: pins) { location in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    Image(systemName: "book.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .onTapGesture {
                            // ¿alerta con el título al pinchar?
                        }
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        region = manager.region
                    }
                } label: {
                    Image(systemName: "location")
                }
            }
        }
        .onAppear {
            manager.checkIfLocationServicesIsEnabled()
            manager.startLocating()
        }
        .onDisappear { manager.stopLocating() }
        .task {
            if pins.isEmpty {
                region = manager.region
            } else {
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pins[0].latitude, longitude: pins[0].longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            }
        }
    }
}

struct RDMapView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RDMapView(pins: [RDLocation.dataTest])
                .environmentObject(LocationManager())
        }
    }
}
