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
                if success {
                    // Matching with biometrics
                    model.isBiometricsAllowed = true
                } else {
                    model.isBiometricsAllowed = false
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
    
    struct MyModifier: ViewModifier {
        @Binding var showingEditUser: Bool
        @Binding var showingClosingAlert: Bool
        @Binding var isUnlocked: Bool
        @Binding var showingSelectorPicker: Bool
        @Binding var showingImagePicker: Bool
        @Binding var showingCameraPicker: Bool
        @Binding var inputImage: UIImage?
        
        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $showingEditUser) {
                    EditUserPasswordView()
                }
                .alert("¿Seguro que quieres cerrar la sesión?", isPresented: $showingClosingAlert) {
                    Button("Cancelar", role: .cancel) { }
                    Button("Cerrar", role: .destructive) {
                        isUnlocked = false
                    }
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
        }
    }
}
