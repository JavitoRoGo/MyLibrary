//
//  UserConfigViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/9/23.
//

import LocalAuthentication
import SwiftUI

extension UserConfigView {
	func authenticate() {
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reasonForTouchID = "Usa TouchID para identificarte y acceder a la app."
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonForTouchID) { success, error in
				DispatchQueue.main.async {
					if success {
						// Matching with biometrics
						model.isBiometricsAllowed = true
					} else {
						model.isBiometricsAllowed = false
					}
				}
			}
		} else {
			// no autorización para biometrics
			model.isBiometricsAllowed = false
		}
	}
	
	func getBioMetricStatus() -> Bool {
		let scanner = LAContext()
		if scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
			return true
		}
		return false
	}
	
	func authenticateToDelete(_ tag: Int) {
		let context = LAContext()
		var error: NSError?
		
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reasonForTouchID = "Usa TouchID para confirmar la operación de borrado."
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonForTouchID) { success, error in
				if success {
					DispatchQueue.main.async {
						// Matching with biometrics
						if tag == 0 {
							// Borrar solo datos
							model.user = User(id: model.user.id, username: model.user.username, nickname: model.user.nickname, books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
							showingDeleteButtons = false
							showingSuccessfulDeleting = true
						} else if tag == 1 {
							// Borrar usuario y salir
							model.user = User.emptyUser
							keychain.delete("storedPassword")
							model.isBiometricsAllowed = false
							showingDeleteButtons = false
							isUnlocked = false
						}
					}
				}
			}
		} else {
			withAnimation {
				showingPasswordField = true
			}
		}
	}
	
	struct UserConfigViewModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		@Binding var showingEditUser: Bool
		
		@Binding var showingDeletingDatas: Bool
		@Binding var showingDeletingUser: Bool
		@Binding var showingPasswordField: Bool
		
		@Binding var password: String
		@Binding var showingSuccessfulDeleting: Bool
		@Binding var showingWrongPassword: Bool
		
		let authenticateToDelete: (Int) -> Void
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Ajustes personales")
				.navigationBarTitleDisplayMode(.inline)
				.sheet(isPresented: $showingEditUser) {
					EditUserPasswordView()
				}
				.alert("⚠️\n¡Atención!", isPresented: $showingDeletingDatas) {
					Button("Cancelar", role: .cancel) { }
					Button("Borrar", role: .destructive) {
						if model.isBiometricsAllowed {
							authenticateToDelete(0)
						} else {
							withAnimation {
								showingPasswordField = true
							}
						}
					}
				} message: {
					Text("Estás a punto de borrar TODOS los datos de la app.\n¿Estás seguro que deseas continuar?")
				}
				.alert("⚠️\n¡Atención!", isPresented: $showingDeletingUser) {
					Button("Cancelar", role: .cancel) { }
					Button("Borrar y salir", role: .destructive) {
						if model.isBiometricsAllowed {
							authenticateToDelete(1)
						} else {
							withAnimation {
								showingPasswordField = true
							}
						}
					}
				} message: {
					Text("¿Estás seguro que deseas borrar tu usuario y salir de la app?")
				}
				.alert("Se han borrado los datos correctamente.", isPresented: $showingSuccessfulDeleting) {
					Button("Continuar") { }
				}
				.alert("¡UPS!", isPresented: $showingWrongPassword) {
					Button("Volver a intentar") {
						password = ""
					}
				} message: {
					Text("La contraseña no es correcta.")
				}
		}
	}
}
