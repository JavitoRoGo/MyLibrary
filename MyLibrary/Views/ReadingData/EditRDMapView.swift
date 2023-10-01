//
//  EditRDMapView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 22/3/23.
//

import MapKit
import SwiftUI

struct EditRDMapView: View {
	@EnvironmentObject var manager: LocationManager
    @Environment(\.dismiss) var dismiss
    
//    @State var region = MKCoordinateRegion()
    @State private var pins = [RDLocation]()
    @Binding var location: RDLocation?
    
    var body: some View {
        VStack(spacing: 15) {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.secondary)
                .frame(width: 75, height: 5)
            ZStack(alignment: .bottomTrailing) {
                MapViewHelper()
                    .frame(width: 400, height: 550)
                    .environmentObject(manager)
                HStack(spacing: 15) {
                    if pins.isEmpty {
                        Button {
                            let newPin = RDLocation(id: UUID(), latitude: manager.mapView.region.center.latitude, longitude: manager.mapView.region.center.longitude)
                            pins.append(newPin)
                            manager.addPin(coordinate: CLLocationCoordinate2D(latitude: newPin.latitude, longitude: newPin.longitude))
                        } label: {
                            Text("Añadir marcador")
                        }
                        .buttonStyle(.bordered)
                        .offset(y: -7)
                    }
                    Button {
                        withAnimation {
                            manager.mapView.region = manager.region
                        }
                    } label: {
                        Image(systemName: "location")
                    }
                    .buttonStyle(.borderedProminent)
                    .offset(x: -7, y: -7)
                }
            }
            HStack {
                Button {
                    location = RDLocation(id: UUID(), latitude: manager.mapView.region.center.latitude, longitude: manager.mapView.region.center.longitude)
                    dismiss()
                } label: {
                    Label("Actual", systemImage: "location.north.fill")
                }
                Button {
                    if let place = manager.pickedPlaceMark {
                        location = RDLocation(id: UUID(), latitude: place.location!.coordinate.latitude, longitude: place.location!.coordinate.longitude)
                    } else if let place = manager.pickedLocation {
                        location = RDLocation(id: UUID(), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
                    }
                    dismiss()
                } label: {
                    Label("Selección", systemImage: "pin.fill")
                }
                .disabled(pins.isEmpty)
            }
            .buttonStyle(.bordered)
            Text("Puedes guardar la ubicación actual o guardar una ubicación que elijas en el mapa.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical, 30)
        .onAppear {
            manager.checkIfLocationServicesIsEnabled()
            manager.startLocating()
            manager.pickedLocation = nil
            manager.pickedPlaceMark = nil
            manager.mapView.removeAnnotations(manager.mapView.annotations)
            if let coordinate = manager.userLocation?.coordinate {
                manager.mapView.region = .init(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            }
        }
        .onDisappear {
            manager.stopLocating()
        }
    }
}

struct EditRDMapView_Previews: PreviewProvider {
    static var previews: some View {
        EditRDMapView(location: .constant(RDLocation(id: UUID(), latitude: 20, longitude: 20)))
            .environmentObject(LocationManager())
    }
}


struct MapViewHelper: UIViewRepresentable {
	@EnvironmentObject var manager: LocationManager
    
    func makeUIView(context: Context) -> MKMapView {
        manager.mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}
