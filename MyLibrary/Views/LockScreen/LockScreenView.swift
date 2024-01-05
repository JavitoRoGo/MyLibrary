//
//  LockScreenView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/22.
//

import LocalAuthentication
import SwiftUI

struct LockScreenView: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    
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
                        VStack {
                            EachMainViewButton(iconImage: "eyes", iconColor: .orange, number: 0, title: "Leyendo y en espera", destination: EmptyView())
                            EachMainViewButton(iconImage: "calendar", iconColor: .black, number: 0, title: "Gráfica de sesiones", destination: EmptyView())
                            EachMainViewButton(iconImage: "textformat.abc", iconColor: .blue, number: 0, title: "Registros de lectura", destination: EmptyView())
                            EachMainViewButton(iconImage: "books.vertical", iconColor: .green, number: 0, title: "Libros en papel", destination: EmptyView())
                            EachMainViewButton(iconImage: "book.circle", iconColor: .pink, number: 0, title: "eBooks", destination: EmptyView())
							EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .teal, number: 0, title: "Y mucho más...", destination: EmptyView())
                        }
                        .foregroundColor(.secondary)
                        .disabled(true)
                        .scaleEffect(0.85)
						.frame(width: 350)
						
						Spacer()
                        
						Button {
							if preferences.isBiometricsAllowed {
								authenticate()
							} else {
								showingLoginPage = true
							}
						} label: {
							VStack(spacing: 30) {
								if preferences.isBiometricsAllowed {
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
                .modifier(LockScreenViewModifier(showingFirstRunAlert: $showingFirstRunAlert, showingCreateUser: $showingCreateUser, showingLoginPage: $showingLoginPage, showingAlert: $showingAlert, isUnlocked: $isUnlocked, isFirstRun: $isFirstRun))
            }
        }
    }
}

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView()
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
