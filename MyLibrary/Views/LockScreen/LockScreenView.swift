//
//  LockScreenView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/22.
//

import LocalAuthentication
import SwiftUI

struct LockScreenView: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    @EnvironmentObject var rdmodel: RDModel
    @EnvironmentObject var nrmodel: NowReadingModel
    @EnvironmentObject var rsmodel: ReadingSessionModel
    
    @State private var isUnlocked = false
    @State private var showingAlert = false
    @State private var showingCreateUser = false
    @State private var showingLoginPage = false
    
    @AppStorage("isFirstRun") var isFirstRun = true
    @State private var showingFirstRunAlert = false
    
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
                            !model.user.nickname.isEmpty ?
                            "Hola, \(model.user.nickname). Haz login para acceder a todo el contenido de la app." :
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
                                if model.isBiometricsAllowed {
                                    authenticate()
                                } else {
                                    showingLoginPage = true
                                }
                            } label: {
                                VStack(spacing: 30) {
                                    if model.isBiometricsAllowed {
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
                .navigationTitle("Login")
                .onAppear {
                    if isFirstRun {
                        keychain.delete("storedPassword")
                        model.storedPassword = ""
                        showingFirstRunAlert = true
                    }
                }
                .alert("¡Bienvenido a esta fantástica app!\n😊😊😊", isPresented: $showingFirstRunAlert) {
                    Button("Continuar") {
                        isFirstRun = false
                        showingCreateUser = true
                    }
                } message: {
                    Text("\nCrea tu usuario y contraseña para comenzar\n©JRG")
                }
                .alert("Identificación no válida.", isPresented: $showingAlert) {
                    Button("OK") {
                        showingLoginPage = true
                    }
                } message: {
                    Text("Debes identificarte correctamente para acceder al contenido de la app.")
                }
                .sheet(isPresented: $showingLoginPage) {
                    LoginNoBiomView(isUnlocked: $isUnlocked)
                }
                .sheet(isPresented: $showingCreateUser) {
                    CreateUserView(isUnlocked: $isUnlocked)
                }
                .onAppear(perform: saveDataToUser)
            }
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reasonForTouchID = "Usa TouchID para identificarte y acceder a la app."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonForTouchID) { success, error in
                if success {
                    // Matching with biometrics
                    isUnlocked = true
                } else {
                    // No matching with biometrics
                    showingAlert = true
                }
            }
        } else {
            // no autorización para biometrics
            model.isBiometricsAllowed = false
        }
    }
    
    func getBioMetricStatus() -> Bool {
        let scanner = LAContext()
        if scanner.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: .none) {
            return true
        }
        return false
    }
    
    func saveDataToUser() {
        model.user.books = bmodel.books
        model.user.ebooks = emodel.ebooks
        model.user.readingDatas = rdmodel.readingDatas
        model.user.nowReading = nrmodel.readingList
        model.user.nowWaiting = nrmodel.waitingList
        model.user.sessions = rsmodel.readingSessionList
        model.user.myPlaces = model.myPlaces
    }
}

struct LockScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenView()
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
            .environmentObject(EbooksModel())
            .environmentObject(RDModel())
            .environmentObject(NowReadingModel())
            .environmentObject(ReadingSessionModel())
    }
}
