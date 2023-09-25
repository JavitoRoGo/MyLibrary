//
//  LoginNoBiomView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/23.
//

import SwiftUI

struct LoginNoBiomView: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    @Environment(\.dismiss) var dismiss
    @Binding var isUnlocked: Bool
    
    @State private var username = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var showingCreateUser = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("Introduce tu email", text: $username)
                            .keyboardType(.emailAddress)
                        Spacer()
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundColor(.secondary.opacity(username.isEmpty ? 1 : 0))
                    }
                } header: {
                    Text("Usuario:")
                } footer: {
                    Label("El formato de email no es correcto.", systemImage: "exclamationmark.circle")
                        .opacity(username.isValidEmail() ? 0 : 1)
                }
                Section {
                    HStack {
                        if isPasswordVisible {
                            TextField("Contraseña", text: $password)
                        } else {
                            SecureField("Contraseña", text: $password)
                        }
                        Spacer()
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Contraseña:")
                } footer: {
                    Label("Campo requerido.", systemImage: "exclamationmark.circle")
                    .opacity(password.isEmpty ? 1 : 0)
                }
                Section {
					if preferences.storedPassword.isEmpty {
                        Button {
                            showingCreateUser = true
                        } label: {
                            HStack {
                                Spacer()
                                Text("Crea tu usuario y contraseña")
                                Spacer()
                            }
                        }
                    } else {
                        Button {
							if model.userLogic.user.username == username && preferences.storedPassword == password {
                                isUnlocked = true
                            } else {
                                showingAlert = true
                            }
                        } label: {
                            HStack {
                                Spacer()
                                Text("Login")
                                Spacer()
                            }
                        }
                        .disabled(username.isEmpty || password.isEmpty || !username.isValidEmail())
                        .alert("Acceso denegado.", isPresented: $showingAlert) {
                            Button("Intentar de nuevo") { }
                        } message: {
                            Text("El usuario o la contraseña introducidos no son correctos.")
                        }
                    }
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
            .navigationTitle("Introduce tu usuario y contraseña")
            .navigationBarTitleDisplayMode(.inline)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.never)
            .sheet(isPresented: $showingCreateUser) {
                CreateUserView(isUnlocked: $isUnlocked)
            }
        }
    }
}

struct LoginNoBiomView_Previews: PreviewProvider {
    static var previews: some View {
        LoginNoBiomView(isUnlocked: .constant(false))
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
