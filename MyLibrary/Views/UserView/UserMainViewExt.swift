//
//  UserMainViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/8/23.
//

import LocalAuthentication
import SwiftUI

extension UserMainView {
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
    
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        if scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func removeUserImage() {
        let name = imageCoverName(from: model.user.nickname)
        if let path = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
            try? FileManager.default.removeItem(at: path)
        }
    }
    
    struct UserMainViewModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		
        @Binding var showingEditUser: Bool
        @Binding var showingClosingAlert: Bool
        @Binding var isUnlocked: Bool
        @Binding var showingSelectorPicker: Bool
        @Binding var showingImagePicker: Bool
        @Binding var showingCameraPicker: Bool
		@Binding var image: Image?
        @Binding var inputImage: UIImage?
		@Binding var showingDeletingDatas: Bool
		@Binding var showingDeletingUser: Bool
		@Binding var showingPasswordField: Bool
		@Binding var showingSuccessfulDeleting: Bool
		@Binding var showingWrongPassword: Bool
		@Binding var password: String
		
		let loadImage: () -> Void
		let authenticateToDelete: (Int) -> Void
        
        func body(content: Content) -> some View {
            content
				.navigationTitle("Hola, \(model.user.nickname).")
				.onChange(of: inputImage) { newValue in
					loadImage()
					if let newValue {
						saveJpg(newValue, title: model.user.nickname)
					}
				}
				.onAppear {
					let name = imageCoverName(from: model.user.nickname)
					image = getUserImage(from: name)
				}
                .sheet(isPresented: $showingEditUser) {
                    EditUserPasswordView()
                }
                .confirmationDialog("Elige una opción para la imagen:", isPresented: $showingSelectorPicker) {
                    Button("Canclear", role: .cancel) { }
                    Button("Seleccionar foto") {
                        showingImagePicker = true
                    }
                    Button("Hacer foto") {
                        showingCameraPicker = true
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .sheet(isPresented: $showingCameraPicker) {
                    CameraPicker(image: $inputImage)
                }
				.alert("¿Seguro que quieres cerrar la sesión?", isPresented: $showingClosingAlert) {
					Button("Cancelar", role: .cancel) { }
					Button("Cerrar", role: .destructive) {
						isUnlocked = false
					}
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
