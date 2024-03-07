//
//  CreateUserView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import SwiftUI

struct CreateUserView: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    @Environment(\.dismiss) var dismiss
    @Binding var isUnlocked: Bool
    
    @State private var nickname = ""
    @State private var username = ""
    @State private var repeatPassword = ""
    
    var isValidAndEqual: Bool {
        if repeatPassword.isEmpty {
            return false
        }
		return preferences.isValid && repeatPassword == preferences.password
    }
    
    var body: some View {
		NavigationStack {
            Form {
                Section {
                    TextField("Introduce tu usuario", text: $nickname)
                } footer: {
                    Text("Introduce un nombre de usuario que te identifique.")
                }
                
                Section {
                    TextField("Introduce tu email", text: $username)
                        .keyboardType(.emailAddress)
                } footer: {
                    Text("Introduce un email para registrarte en la app. \(username.isValidEmail() ? "" : "El formato de email no es correcto.")")
                }
                
                Section {
                    SecureField("Introduce la contraseña", text: $preferences.password)
                    SecureField("Repite la contraseña", text: $repeatPassword)
					
					List(preferences.validations) { validation in
                        HStack {
                            Image(systemName: validation.state == .success ? "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(validation.state == .success ? .green : .gray.opacity(0.3))
                            Text(validation.validationType.message(fieldName: validation.field.rawValue))
                                .strikethrough(validation.state == .success)
                                .font(.caption)
                                .foregroundColor(validation.state == .success ? .secondary : .primary)
                        }
                        .padding(.leading, 15)
                    }
                    HStack {
						Image(systemName: preferences.password == repeatPassword && !repeatPassword.isEmpty ? "checkmark.circle.fill" : "checkmark.circle")
							.foregroundColor(preferences.password == repeatPassword && !repeatPassword.isEmpty ? .green : .gray.opacity(0.3))
                        Text("Repite la contraseña.")
							.strikethrough(preferences.password == repeatPassword && !repeatPassword.isEmpty)
                            .font(.caption)
							.foregroundColor(preferences.password == repeatPassword && !repeatPassword.isEmpty ? .secondary : .primary)
                    }
                    .padding(.leading, 15)
                }
                
                Section {
                    Button {
						model.userLogic.user.id = UUID()
						model.userLogic.user.nickname = nickname
						model.userLogic.user.username = username
						if let hashed = hashPassword(repeatPassword) {
							model.userLogic.user.password = hashed
						}
                        isUnlocked = true
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: isValidAndEqual ? "lock.open.fill" : "lock.fill")
                            Text("Crear")
                        }
						.frame(maxWidth: .infinity)
                    }
                    .disabled(!isValidAndEqual || username.isEmpty || !username.isValidEmail())
                }
                Section {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancelar")
							.frame(maxWidth: .infinity)
                    }
                }
            }
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .navigationTitle("Crea tu usuario y contraseña")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(isUnlocked: .constant(false))
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
