//
//  UserViewModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import Combine
import SwiftUI

final class UserViewModel: ObservableObject {
	// Propiedades Published
	@Published var user: User {
		didSet {
			Task {
				await saveToJson(userJson, user)
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
	@Published var password = ""
	@Published var validations: [Validation] = []
	@Published var isValid: Bool = false
	
	var tempQuotesArray: [Quote] = []
	
	var storedPassword: String { keychain.get("storedPassword") ?? "" }
	@AppStorage("isBiometricsAllowed") var isBiometricsAllowed = false
	
	@AppStorage("preferredGridView") var preferredGridView = false
	var preferredListView: Bool {
		get { !preferredGridView }
		set { preferredGridView = !newValue }
	}
	
	@AppStorage("preferredAppearance") var preferredAppearance = 0
	var customAppearance: UserAppearance {
		get { .init(rawValue: preferredAppearance)! }
		set { preferredAppearance = newValue.rawValue }
	}
	public static var deviceColorScheme: ColorScheme = .light
	
	private var cancellableSet: Set<AnyCancellable> = []
	
	init() {
		guard let decoded: User = Bundle.main.searchAndDecode(userJson) else { fatalError() }
		user = decoded
		if !user.myPlaces.contains(soldText) && !user.myPlaces.contains(donatedText) {
			user.myPlaces += [donatedText, soldText]
		}
		
		// Validations
		passwordPublisher
			.receive(on: RunLoop.main)
			.assign(to: \.validations, on: self)
			.store(in: &cancellableSet)
		
		// isValid
		passwordPublisher
			.receive(on: RunLoop.main)
			.map { validations in
				return validations.filter { validation in
					return ValidationState.failure == validation.state
				}.isEmpty
			}
			.assign(to: \.isValid, on: self)
			.store(in: &cancellableSet)
	}
	
	private var passwordPublisher: AnyPublisher<[Validation], Never> {
		$password
			.removeDuplicates()
			.map { password in
				var validations: [Validation] = []
				validations.append(Validation(string: password, id: 0, field: .password, validationType: .isNotEmpty))
				validations.append(Validation(string: password, id: 1, field: .password, validationType: .minCharacters(min: 8)))
				validations.append(Validation(string: password, id: 2, field: .password, validationType: .hasSymbols))
				validations.append(Validation(string: password, id: 3, field: .password, validationType: .hasUppercasedLetters))
				validations.append(Validation(string: password, id: 4, field: .password, validationType: .hasNumbers))
				return validations
			}.eraseToAnyPublisher()
	}
	
	// OBJETIVOS DE LECTURA:
	
	// Diario
	@AppStorage("dailyPagesTarget") var dailyPagesTarget: Int = 40
	@AppStorage("dailyTimeTarget") var dailyTimeTarget: Double = 1.0
	// Semanal
	@AppStorage("weeklyPagesTarget") var weeklyPagesTarget: Int = 250
	@AppStorage("weeklyTimeTarget") var weeklyTimeTarget: Double = 7.0
	// Mensual
	@AppStorage("monthlyPagesTarget") var monthlyPagesTarget: Int = 1000
	@AppStorage("monthlyTimeTarget") var monthlyBooksTarget: Int = 4
	// Anual
	@AppStorage("yearlyPagesTarget") var yearlyPagesTarget: Int = 8000
	@AppStorage("yearlyTimeTarget") var yearlyBooksTarget: Int = 40
}
