//
//  UserConfigViewAppearanceExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 18/9/23.
//

import SwiftUI

extension UserConfigView {
	var appearanceButtons: some View {
		Section {
			Button {
				withAnimation {
					preferences.customAppearance = .system
				}
			} label: {
				HStack {
					Image(systemName: "gearshape.2")
					Text("Auto")
						.foregroundColor(.primary)
					Spacer()
					if preferences.customAppearance == .system {
						Image(systemName: "checkmark")
							.animation(.easeIn)
					}
				}
			}
			Button {
				withAnimation {
					preferences.customAppearance = .light
				}
			} label: {
				HStack {
					Image(systemName: "sun.max")
					Text("Claro")
						.foregroundColor(.primary)
					Spacer()
					if preferences.customAppearance == .light {
						Image(systemName: "checkmark")
							.animation(.easeIn)
					}
				}
			}
			Button {
				withAnimation {
					preferences.customAppearance = .dark
				}
			} label: {
				HStack {
					Image(systemName: "moon.fill")
					Text("Oscuro")
						.foregroundColor(.primary)
					Spacer()
					if preferences.customAppearance == .dark {
						Image(systemName: "checkmark")
							.animation(.easeIn)
					}
				}
			}
		} header: {
			Text("Aspecto")
		}
	}
}
