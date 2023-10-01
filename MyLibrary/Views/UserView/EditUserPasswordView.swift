//
//  EditUserPasswordView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/1/23.
//

import SwiftUI

struct EditUserPasswordView: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    @Environment(\.dismiss) var dismiss
    
    @State private var nickname = ""
    @State private var username = ""
    @State private var repeatPassword = ""
    @State private var isPasswordVisible = false
    
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
                    TextField("Cambia tu usuario", text: $nickname)
                }
                
                Section {
                    TextField("Cambia el email de registro", text: $username)
                        .keyboardType(.emailAddress)
                } footer: {
                    Text("\(username.isValidEmail() ? "" : "El formato de email no es correcto.")")
                }
                
                Section {
                    HStack {
                        if isPasswordVisible {
							TextField("Introduce la nueva contraseña", text: $preferences.password)
                        } else {
							SecureField("Introduce la nueva contraseña", text: $preferences.password)
                        }
                        Spacer()
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.secondary)
                        }
                    }
                    HStack {
                        if isPasswordVisible {
                            TextField("Repite la nueva contraseña", text: $repeatPassword)
                        } else {
                            SecureField("Repite la nueva contraseña", text: $repeatPassword)
                        }
                        Spacer()
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.secondary)
                        }
                    }
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
						model.userLogic.user.nickname = nickname
						model.userLogic.user.username = username
                        keychain.set(repeatPassword, forKey: "storedPassword")
                        if keychain.set(repeatPassword, forKey: "storedPassword") {
                            print("Usuario y contraseña cambiados correctamente")
                        } else {
                            print("No se guardó la contraseña")
                        }
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: isValidAndEqual ? "lock.open.fill" : "lock.fill")
                            Text("Cambiar")
                            Spacer()
                        }
                    }
                    .disabled(!isValidAndEqual || username.isEmpty || !username.isValidEmail())
                }
                Section {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Cancelar")
                            Spacer()
                        }
                    }
                }
            }
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .navigationTitle("Modifica tu usuario y contraseña")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
				nickname = model.userLogic.user.nickname
				username = model.userLogic.user.username
            }
        }
    }
}

struct EditUserPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EditUserPasswordView()
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
