//
//  GlobalViewModel.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/9/23.
//

import SwiftUI

@Observable
final class GlobalViewModel {
	// Crear una instancia de cada lógica de datos
	
	var userLogic: UserLogic
	
	init(userLogic: UserLogic = .shared) {
		self.userLogic = userLogic
	}
}
