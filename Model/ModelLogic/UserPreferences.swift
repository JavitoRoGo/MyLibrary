//
//  UserPreferences.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 24/9/23.
//

import SwiftUI

final class UserPreferences: ObservableObject {
	@AppStorage("isBiometricsAllowed") var isBiometricsAllowed = false
	
	@AppStorage("preferredGridView") var preferredGridView = false
	
	@AppStorage("preferredAppearance") var preferredAppearance = 0
	var customAppearance: UserAppearance {
		get { .init(rawValue: preferredAppearance)! }
		set { preferredAppearance = newValue.rawValue }
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
