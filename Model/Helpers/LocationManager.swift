//
//  LocationManager.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/3/23.
//

import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
	var manager: CLLocationManager?
	
	@Published var userLocation = CLLocationCoordinate2D()
	@Published var userPermission = false
	@Published var showLocationAlert = false
	@Published var locationAlertTitle = ""
	@Published var locationAlertMessage = ""
    
	func checkIfLocationServicesIsEnabled() {
		if CLLocationManager.locationServicesEnabled() {
			manager = CLLocationManager()
			manager!.delegate = self
		} else {
			locationAlertTitle = "Localización desactivada."
			locationAlertMessage = "Para fijar tu ubicación debes activar la localización en los ajustes del sistema."
			showLocationAlert = true
		}
	}
    
    // Comprobación de los permisos
	private func checkLocationAuthorization() {
		guard let manager else { return }
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted:
			locationAlertTitle = "Localización restringida."
			locationAlertMessage = "Para fijar tu ubicación revisa los ajustes sobre localización en los ajustes del sistema."
			showLocationAlert = true
        case .denied:
			locationAlertTitle = "Localización denegada."
			locationAlertMessage = "Para fijar tu ubicación debes activar la localización en los ajustes del sistema."
			showLocationAlert = true
        case .authorizedAlways, .authorizedWhenInUse:
			userLocation = manager.location!.coordinate
			userPermission = true
        @unknown default:
            break
        }
    }
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		checkLocationAuthorization()
	}
}
