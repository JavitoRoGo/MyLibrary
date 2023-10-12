//
//  LocationModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Reading-data-location data type. A struct used to contain the latitude and longitude coordinates where a book was read. All the properties are required and have to be initialised.
struct RDLocation: Codable, Equatable, Identifiable {
	let id: UUID
	let latitude: Double
	let longitude: Double
}
