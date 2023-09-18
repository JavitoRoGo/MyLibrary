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
			Toggle(isOn: $model.isBiometricsAllowed) {
				Label("Acceder con \(getBioMetricStatus() ? "FaceID" : "TouchID")",
					  systemImage: getBioMetricStatus() ? "faceid" : "touchid")
			}
			.onChange(of: model.isBiometricsAllowed) { newValue in
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
