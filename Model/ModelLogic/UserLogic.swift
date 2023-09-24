//
//  UserLogic.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import Combine
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
	var password = ""
	var validations: [Validation] = []
	var isValid: Bool = false
	
	var tempQuotesArray: [Quote] = []
	
	var storedPassword: String { keychain.get("storedPassword") ?? "" }
	
	private var cancellableSet: Set<AnyCancellable> = []
	
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
//		// Validations
//		passwordPublisher
//			.receive(on: RunLoop.main)
//			.assign(to: \.validations, on: self)
//			.store(in: &cancellableSet)
//		
//		// isValid
//		passwordPublisher
//			.receive(on: RunLoop.main)
//			.map { validations in
//				return validations.filter { validation in
//					return ValidationState.failure == validation.state
//				}.isEmpty
//			}
//			.assign(to: \.isValid, on: self)
//			.store(in: &cancellableSet)
//	}
//	
//	private var passwordPublisher: AnyPublisher<[Validation], Never> {
//		$password
//			.removeDuplicates()
//			.map { password in
//				var validations: [Validation] = []
//				validations.append(Validation(string: password, id: 0, field: .password, validationType: .isNotEmpty))
//				validations.append(Validation(string: password, id: 1, field: .password, validationType: .minCharacters(min: 8)))
//				validations.append(Validation(string: password, id: 2, field: .password, validationType: .hasSymbols))
//				validations.append(Validation(string: password, id: 3, field: .password, validationType: .hasUppercasedLetters))
//				validations.append(Validation(string: password, id: 4, field: .password, validationType: .hasNumbers))
//				return validations
//			}.eraseToAnyPublisher()
//	}
}
