//
//  LockScreenViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/8/23.
//

import Foundation
import LocalAuthentication

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
    
    func saveDataToUser() {
        model.user.books = bmodel.books
        model.user.ebooks = emodel.ebooks
        model.user.readingDatas = rdmodel.readingDatas
        model.user.nowReading = nrmodel.readingList
        model.user.nowWaiting = nrmodel.waitingList
        model.user.sessions = rsmodel.readingSessionList
        model.user.myPlaces = model.myPlaces
    }
}
