//
//  UserConfigView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 17/9/23.
//

import LocalAuthentication
import SwiftUI

struct UserConfigView: View {
	@EnvironmentObject var model: UserViewModel
	
	@Binding var isUnlocked: Bool
	@State var showingEditUser = false
	
	@State var showingDeleteButtons = false
	@State var showingDeletingDatas = false
	@State var showingDeletingUser = false
	@State var showingPasswordField = false
	
	@State var password = ""
	@State var deleteOperation = 0
	@State var showingSuccessfulDeleting = false
	@State var showingWrongPassword = false
	
    var body: some View {
		NavigationStack {
			List {
				Section {
					Button {
						withAnimation {
							model.customAppearance = .system
						}
					} label: {
						HStack {
							Image(systemName: "gearshape.2")
							Text("Auto")
								.foregroundColor(.primary)
							Spacer()
							if model.customAppearance == .system {
								Image(systemName: "checkmark")
									.animation(.easeIn)
							}
						}
					}
					Button {
						withAnimation {
							model.customAppearance = .light
						}
					} label: {
						HStack {
							Image(systemName: "sun.max")
							Text("Claro")
								.foregroundColor(.primary)
							Spacer()
							if model.customAppearance == .light {
								Image(systemName: "checkmark")
									.animation(.easeIn)
							}
						}
					}
					Button {
						withAnimation {
							model.customAppearance = .dark
						}
					} label: {
						HStack {
							Image(systemName: "moon.fill")
							Text("Oscuro")
								.foregroundColor(.primary)
							Spacer()
							if model.customAppearance == .dark {
								Image(systemName: "checkmark")
									.animation(.easeIn)
							}
						}
					}
				} header: {
					Text("Aspecto")
				}
				
				Section {
					Toggle(isOn: $model.preferredListView) {
						Label("Listado de libros", systemImage: "list.star")
					}
					Toggle(isOn: $model.preferredGridView) {
						Label("Parrilla de portadas", systemImage: "square.grid.3x3")
					}
				} footer: {
					Text("Elige la vista por defecto para los libros y ebooks.")
				}
				
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
				
				deleteButtons
			}
			.modifier(UserConfigViewModifier(showingEditUser: $showingEditUser, showingDeletingDatas: $showingDeletingDatas, showingDeletingUser: $showingDeletingUser, showingPasswordField: $showingPasswordField, password: $password, showingSuccessfulDeleting: $showingSuccessfulDeleting, showingWrongPassword: $showingWrongPassword, authenticateToDelete: authenticateToDelete(_:)))
		}
    }
}

struct UserConfigView_Previews: PreviewProvider {
    static var previews: some View {
		UserConfigView(isUnlocked: .constant(true))
			.environmentObject(UserViewModel())
    }
}
