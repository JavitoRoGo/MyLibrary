//
//  LockScreenView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/22.
//

import LocalAuthentication
import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var model: GlobalViewModel
    
    @State var isUnlocked = false
    @State var showingAlert = false
    @State var showingCreateUser = false
    @State var showingLoginPage = false
    
    @AppStorage("isFirstRun") var isFirstRun = true
    @State var showingFirstRunAlert = false
    
    var body: some View {
        if isUnlocked {
            ContentView(isUnlocked: $isUnlocked)
        } else {
            NavigationStack {
                ZStack {
                    Image("opened")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(0.4)
                    
                    VStack {
                        Text(
							!model.userLogic.user.nickname.isEmpty ?
							"Hola, \(model.userLogic.user.nickname). Haz login para acceder a todo el contenido de la app." :
                            "Introduce tu usuario para acceder a todo el contenido de la app."
                        )
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(ButtonBackground())
                            .padding(.horizontal, 10)
                        VStack {
                            EachMainViewButton(iconImage: "eyes", iconColor: .orange, number: 0, title: "Leyendo y en espera", destination: EmptyView())
                            EachMainViewButton(iconImage: "calendar", iconColor: .black, number: 0, title: "Gráfica de sesiones", destination: EmptyView())
                            EachMainViewButton(iconImage: "textformat.abc", iconColor: .blue, number: 0, title: "Registros de lectura", destination: EmptyView())
                            EachMainViewButton(iconImage: "books.vertical", iconColor: .green, number: 0, title: "Libros en papel", destination: EmptyView())
                            EachMainViewButton(iconImage: "book.circle", iconColor: .pink, number: 0, title: "eBooks", destination: EmptyView())
                        }
                        .foregroundColor(.secondary)
                        .disabled(true)
                        .scaleEffect(0.85)
                        VStack {
                            Button {
								if model.userLogic.isBiometricsAllowed {
                                    authenticate()
                                } else {
                                    showingLoginPage = true
                                }
                            } label: {
                                VStack(spacing: 30) {
									if model.userLogic.isBiometricsAllowed {
                                        if getBioMetricStatus() {
                                            Image(systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                                                .font(.system(size: 50))
                                        }
                                    }
                                    Text("Login").bold()
                                }
                                .padding()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.horizontal, 35)
                }
                .modifier(LockScreenViewModifier(showingFirstRunAlert: $showingFirstRunAlert, showingCreateUser: $showingCreateUser, showingLoginPage: $showingLoginPage, showingAlert: $showingAlert, isUnlocked: $isUnlocked, isFirstRun: $isFirstRun))
            }
        }
    }
}

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView()
			.environmentObject(GlobalViewModel.preview)
    }
}
