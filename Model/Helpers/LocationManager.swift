//
//  LocationManager.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/3/23.
//

import MapKit

@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate, MKMapViewDelegate {
    // Manager opcional porque puede ser que la localización no esté activa
    private var manager: CLLocationManager?
    
	var region = MKCoordinateRegion()
        
    // Propiedades para mostrar el mapa que permite crear un draggable pin
	var mapView: MKMapView = .init()
	var pickedPlaceMark: CLPlacemark?
    //No entiendo el sentido de las dos siguientes:
	var pickedLocation: CLLocation?
	var userLocation: CLLocation?
    
    override init() {
        super.init()
        mapView.delegate = self
    }
    
    // Comprobación si está activa la localización
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager!.delegate = self
            manager!.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Show an alert telling this is off and to turn it on")
        }
    }
    
    // Comprobación de los permisos
    private func checkLocationAuthorization() {
        guard let manager else { return }
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted for any reason.")
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        @unknown default:
            break
        }
    }
    
    // Comprobación de cambios en las autorizaciones
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Este método se ejecuta siempre que se crea el locationManager
        checkLocationAuthorization()
    }
    
    func startLocating() {
        guard let manager else { return }
        manager.startUpdatingLocation()
    }
    
    func stopLocating() {
        guard let manager else { return }
        manager.stopUpdatingLocation()
    }
    
    // Comprobación de cambios en la localización del usuario al moverse: se ejecuta cada vez que se mueve
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        userLocation = currentLocation
    }
    
    // MARK: - Métodos para añadir draggable pin y obtener sus coordenadas
    
    // Crear un pin
    func addPin(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        pickedLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
    
    // Draggable pin
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let marker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DELIVERYPIN")
        marker.isDraggable = true
        marker.canShowCallout = false
        
        return marker
    }
    
    // Cambio en las localizaciones
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        guard let newLocation = view.annotation?.coordinate else { return }
        self.pickedLocation = .init(latitude: newLocation.latitude, longitude: newLocation.longitude)
        updatePlaceMark(location: .init(latitude: newLocation.latitude, longitude: newLocation.longitude))
    }
    
    // Actualizar el placemark al moverlo en el mapa
    func updatePlaceMark(location: CLLocation) {
        Task {
            do {
                guard let place = try await reverseLocation(location: location) else { return }
                await MainActor.run(body: {
                    self.pickedPlaceMark = place
                })
            } catch {
                // Error
            }
        }
    }
    
    // Obtener las coordenadas desde el mapa al mover el pin
    func reverseLocation(location: CLLocation) async throws -> CLPlacemark? {
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
}
