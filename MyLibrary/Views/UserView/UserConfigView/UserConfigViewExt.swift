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
						preferences.isBiometricsAllowed = true
					} else {
						preferences.isBiometricsAllowed = false
					}
				}
			}
		} else {
			// no autorización para biometrics
			preferences.isBiometricsAllowed = false
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
							model.userLogic.user = User(id: model.userLogic.user.id, username: model.userLogic.user.username, password: model.userLogic.user.password, nickname: model.userLogic.user.nickname, books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
							showingDeleteButtons = false
							showingSuccessfulDeleting = true
						} else if tag == 1 {
							// Borrar usuario y salir
							model.userLogic.user = User.emptyUser
							preferences.isBiometricsAllowed = false
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
	
	func shareAction() {
		let userUrl = getURLToShare(from: "USERDATA.json")
		let urls = [userUrl]
		
		let ac = UIActivityViewController(activityItems: urls, applicationActivities: nil)
		let scenes = UIApplication.shared.connectedScenes
		let windowScene = scenes.first as? UIWindowScene
		let window = windowScene?.windows.first
		window?.rootViewController!.present(ac, animated: true, completion: nil)
	}
	
	struct UserConfigViewModifier: ViewModifier {
		@Environment(GlobalViewModel.self) var model
		@EnvironmentObject var preferences: UserPreferences
		@Binding var showingEditUser: Bool
		
		@Binding var isExporting: Bool
		@Binding var isImporting: Bool
		@Binding var importOperation: Int
		@Binding var showingImporting: Bool
		
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
				.fileExporter(isPresented: $isExporting, document: JsonExportingDocument(model.userLogic.user), contentType: .json, defaultFilename: "userData.json") { result in
					if case .failure(let error) = result {
						print("Error al exportar: \(error.localizedDescription)")
					} else {
						print("Exportación correcta")
					}
				}
				.alert("¿Qué deseas hacer con los nuevos datos?", isPresented: $isImporting) {
					Button("Sobreescribir", role: .destructive) { importOperation = 0; showingImporting = true }
					Button("Agregar") { importOperation = 1; showingImporting = true }
				}
				.fileImporter(isPresented: $showingImporting, allowedContentTypes: [.json]) { result in
					do {
						let url = try result.get()
						let accessing = url.startAccessingSecurityScopedResource()
						defer {
							if accessing {
								url.stopAccessingSecurityScopedResource()
							}
						}
						let data = try Data(contentsOf: url)
						let importedJson = try JSONDecoder().decode(User.self, from: data)
						if importOperation == 0 {
							model.userLogic.user = importedJson
						} else {
							model.userLogic.user.merge(importedJson)
						}
					} catch {
						print("Algo fue mal con la importación: \(error.localizedDescription)")
					}
				}
				.alert("⚠️\n¡Atención!", isPresented: $showingDeletingDatas) {
					Button("Cancelar", role: .cancel) { }
					Button("Borrar", role: .destructive) {
						if preferences.isBiometricsAllowed {
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
						if preferences.isBiometricsAllowed {
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
