//
//  UserMainViewDeleteExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/9/23.
//

import SwiftUI

extension UserMainView {
	var deleteButtons: some View {
		Section {
			if !showingDeleteButtons {
				Button {
					withAnimation {
						showingDeleteButtons.toggle()
					}
				} label: {
					HStack {
						Spacer()
						Text("Borrar datos y usuario")
						Spacer()
					}
				}
			} else {
				Button(role: .destructive) {
					deleteOperation = 0
					showingDeletingDatas = true
				} label: {
					HStack {
						Spacer()
						Text("Borrar datos")
						Spacer()
					}
				}
				Button(role: .destructive) {
					deleteOperation = 1
					showingDeletingUser = true
				} label: {
					HStack {
						Spacer()
						Text("Eliminar usuario")
						Spacer()
					}
				}
				if showingPasswordField {
					HStack {
						SecureField("Confirma el borrado con la contraseña", text: $password)
						Spacer()
						Button {
							if password == model.storedPassword {
								DispatchQueue.main.async {
									if deleteOperation == 0 {
										// Borrar solo datos
										model.user = User(id: model.user.id, username: model.user.username, nickname: model.user.nickname, books: [], ebooks: [], readingDatas: [], nowReading: [], nowWaiting: [], sessions: [], myPlaces: [], myOwners: [])
										password = ""
										showingPasswordField = false
										showingDeleteButtons = false
										showingSuccessfulDeleting = true
									} else if deleteOperation == 1 {
										// Borrar usuario y salir
										model.user = User.emptyUser
										keychain.delete("storedPassword")
										password = ""
										model.isBiometricsAllowed = false
										showingPasswordField = false
										showingDeleteButtons = false
										isUnlocked = false
									}
								}
							} else {
								showingWrongPassword = true
							}
						} label: {
							Image(systemName: "arrowshape.turn.up.right.circle")
								.foregroundColor(.red)
						}
						.disabled(password.isEmpty)
					}
				}
				Button {
					withAnimation {
						password = ""
						showingPasswordField = false
						showingDeleteButtons.toggle()
					}
				} label: {
					HStack {
						Spacer()
						Text("Ocultar")
						Spacer()
					}
				}
			}
		}
	}
}
