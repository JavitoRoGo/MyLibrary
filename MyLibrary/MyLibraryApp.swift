//
//  MyLibraryApp.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

@main
struct MyLibraryApp: App {
    @StateObject var globalModel = GlobalViewModel()
    @StateObject var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            LockScreenView()
                .environmentObject(globalModel)
                .environmentObject(locationManager)
				.onAppear {
					UIApplication.shared.addTapGestureRecognizer()
				}
				.preferredColorScheme(
					UserAppearance.setSystemColorScheme(globalModel.userLogic.customAppearance)()
				)
        }
    }
}

// Extension para ocultar el teclado al pulsar sobre cualquier parte de la pantalla
public extension UIApplication {
    func addTapGestureRecognizer() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
