//
//  UserConfigViewIDExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 18/9/23.
//

import SwiftUI

extension UserConfigView {
	var faceIDButtons: some View {
		Section {
			Toggle(isOn: $model.userLogic.isBiometricsAllowed) {
				Label("Acceder con \(getBioMetricStatus() ? "FaceID" : "TouchID")",
					  systemImage: getBioMetricStatus() ? "faceid" : "touchid")
			}
			.onChange(of: model.userLogic.isBiometricsAllowed) { _, newValue in
				if newValue {
					authenticate()
				}
			}
			Button {
				showingEditUser = true
			} label: {
				HStack {
					Spacer()
					Text("Cambiar usuario y contraseña")
					Spacer()
				}
			}
		}
	}
}
