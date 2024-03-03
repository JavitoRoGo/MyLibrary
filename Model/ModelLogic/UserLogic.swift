//
//  UserLogic.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import SwiftUI

@Observable
/// A class to handle all the logic for User production and preview data.
///
/// It conforms to the new Observation API.
final class UserLogic {
	// Patrón singleton: siempre se llamará al shared
	/// A static property that belongs to the class and uses the singleton pattern for production data.
	static let shared = UserLogic()
	/// A static property that belongs to the class and uses the singleton pattern for preview data.
	static let test = UserLogic(persistence: PersistencePreview())
	
	/// A property to contain the persistence type, so it can handle preview and production data.
	let persistence: PersistenceInteractor
	
	// Propiedades Published
	/// The main data of the app.
	var user: User {
		didSet {
			do {
				try persistence.saveUser(user)
				print("Datos guardados:\n\(persistence.docURL.absoluteString)")
			} catch {
				// gestionar el error y mostrar alguna alerta al usuario
				print("Error en el guardado: \(error.localizedDescription)")
			}
			
			// Actualizar datos para el widget
			Task {
				await fetchDataToWidget()
			}
			// Actualizar datos para el Watch
			Task {
				// temporalmente deshabilitado
//				await fetchDatatoWatch()
			}
		}
	}
	
	/// A property used to temporally store all the quotes created during a reading session, so they are ready to be saved when creating the new reading session at the end.
	var tempQuotesArray: [Quote] = []
	
	/// The init method to initialise the ``persistence`` class property.
	/// - Parameter persistence: If not defined, by default it is initialised as production data persistence type.
	private init(persistence: PersistenceInteractor = Persistence()) {
		// Valor de persistencia por defecto para los datos de producción
		self.persistence = persistence
		
		do {
			self.user = try self.persistence.loadUser()
			print("Datos cargados:\n\(persistence.docURL.absoluteString)")
		} catch {
			// gestionar el error y mostrar alguna alerta al usuario
			print("Error en la carga: \(error.localizedDescription)")
			self.user = User.emptyUser
		}
		
		if !user.myPlaces.contains(soldText) && !user.myPlaces.contains(donatedText) {
			user.myPlaces += [donatedText, soldText]
		}
	}
}

let soldText = "Vendido"
let donatedText = "Donado"
