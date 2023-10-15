//
//  LocationModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/23.
//

import Foundation

/// Reading-data-location data type.
///
/// A struct used to contain the latitude and longitude coordinates where a book was read. All the properties are required and have to be initialised.
struct RDLocation: Codable, Equatable, Identifiable {
	/// An unique identifier for each location instance, created using the UUID init.
	let id: UUID
	/// The latitude magnitude for the location.
	let latitude: Double
	/// The longitude magnitude for the location.
	let longitude: Double
}
