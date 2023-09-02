//
//  CreateUserView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/22.
//

import SwiftUI

struct CreateUserView: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var isUnlocked: Bool
    
    @State private var nickname = ""
    @State private var username = ""
    @State private var repeatPassword = ""
    @State private var isPasswordVisible = false
    
    var isValidAndEqual: Bool {
        if repeatPassword.isEmpty {
            return false
        }
        return model.isValid && repeatPassword == model.password
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
                    HStack {
                        if isPasswordVisible {
                            TextField("Introduce la contraseña", text: $model.password)
                        } else {
                            SecureField("Introduce la contraseña", text: $model.password)
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
                            TextField("Repite la contraseña", text: $repeatPassword)
                        } else {
                            SecureField("Repite la contraseña", text: $repeatPassword)
                        }
                        Spacer()
                        Button {
                            isPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.secondary)
                        }
                    }
                    List(model.validations) { validation in
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
                        Image(systemName: model.password == repeatPassword && !repeatPassword.isEmpty ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundColor(model.password == repeatPassword && !repeatPassword.isEmpty ? .green : .gray.opacity(0.3))
                        Text("Repite la contraseña.")
                            .strikethrough(model.password == repeatPassword && !repeatPassword.isEmpty)
                            .font(.caption)
                            .foregroundColor(model.password == repeatPassword && !repeatPassword.isEmpty ? .secondary : .primary)
                    }
                    .padding(.leading, 15)
                }
                
                Section {
                    Button {
						model.user.id = UUID()
                        model.user.nickname = nickname
                        model.user.username = username
                        keychain.set(repeatPassword, forKey: "storedPassword")
                        if keychain.set(repeatPassword, forKey: "storedPassword") {
                            print("Contraseña guardada correctamente")
                        } else {
                            print("No se guardó la contraseña")
                        }
                        isUnlocked = true
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: isValidAndEqual ? "lock.open.fill" : "lock.fill")
                            Text("Crear")
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
            .navigationTitle("Crea tu usuario y contraseña")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateUserView(isUnlocked: .constant(false))
            .environmentObject(UserViewModel())
    }
}
