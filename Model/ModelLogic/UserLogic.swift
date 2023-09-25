//
//  UserLogic.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import SwiftUI

@Observable
final class UserLogic {
	// Patrón singleton: siempre se llamará al shared
	static let shared = UserLogic()
	
	let persistence: PersistenceInteractor
	
	// Propiedades Published
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
	
	var tempQuotesArray: [Quote] = []
	
	init(persistence: PersistenceInteractor = Persistence()) {
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
