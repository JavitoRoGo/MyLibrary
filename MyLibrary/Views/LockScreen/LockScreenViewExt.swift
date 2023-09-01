//
//  LockScreenViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/8/23.
//

import LocalAuthentication
import SwiftUI

extension LockScreenView {
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reasonForTouchID = "Usa TouchID para identificarte y acceder a la app."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonForTouchID) { success, error in
                if success {
                    // Matching with biometrics
                    isUnlocked = true
                } else {
                    // No matching with biometrics
                    showingAlert = true
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
    
    struct LockScreenViewModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		
        @Binding var showingFirstRunAlert: Bool
        @Binding var showingCreateUser: Bool
        @Binding var showingLoginPage: Bool
        @Binding var showingAlert: Bool
        @Binding var isUnlocked: Bool
        @Binding var isFirstRun: Bool
        
        func body(content: Content) -> some View {
            content
				.navigationTitle("Login")
                .alert("¡Bienvenido a esta fantástica app!\n😊😊😊", isPresented: $showingFirstRunAlert) {
                    Button("Continuar") {
                        isFirstRun = false
                        showingCreateUser = true
                    }
                } message: {
                    Text("\nCrea tu usuario y contraseña para comenzar\n©JRG")
                }
                .alert("Identificación no válida.", isPresented: $showingAlert) {
                    Button("OK") {
                        showingLoginPage = true
                    }
                } message: {
                    Text("Debes identificarte correctamente para acceder al contenido de la app.")
                }
                .sheet(isPresented: $showingLoginPage) {
                    LoginNoBiomView(isUnlocked: $isUnlocked)
                }
                .sheet(isPresented: $showingCreateUser) {
                    CreateUserView(isUnlocked: $isUnlocked)
                }
				.onAppear {
					if isFirstRun {
						keychain.delete("storedPassword")
						model.storedPassword = ""
						showingFirstRunAlert = true
					}
				}
        }
    }
}
