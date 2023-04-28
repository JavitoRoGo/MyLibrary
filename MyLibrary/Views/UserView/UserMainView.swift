//
//  UserMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/23.
//

import LocalAuthentication
import SwiftUI

struct UserMainView: View {
    @EnvironmentObject var model: UserViewModel
    @Binding var isUnlocked: Bool
    
    @State private var showingClosingAlert = false
    @State private var showingEditUser = false
    
    @State private var showingImagePicker = false
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                VStack {
                    ZStack(alignment: .bottom) {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: geo.size.height/4, height: geo.size.height/4)
                                .foregroundColor(.secondary)
                            HStack(spacing: 25) {
                                Button("Editar") {
                                    showingImagePicker = true
                                }
                                Button("Borrar") {
                                    self.image = nil
                                    self.inputImage = nil
                                    removeUserImage()
                                }
                            }
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.height/6, height: geo.size.height/6)
                                .foregroundColor(.secondary)
                            Button("Editar") {
                                showingImagePicker = true
                            }
                            .offset(y: -10)
                        }
                    }
                    List {
                        NavigationLink(destination: TargetsMainView()) {
                            HStack {
                                Image(systemName: "chart.pie.fill")
                                    .foregroundColor(.green)
                                Text("Objetivos de lectura")
                            }
                        }
                        NavigationLink(destination: AllQuotesCommentsView()) {
                            HStack {
                                Image(systemName: "quote.bubble")
                                    .foregroundColor(.blue)
                                Text("Citas y comentarios de sesiones")
                            }
                        }
                        NavigationLink(destination: AllCommentsView()) {
                            HStack {
                                Image(systemName: "quote.bubble")
                                    .foregroundColor(.pink)
                                Text("Comentarios por libro")
                            }
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
                        
                        Section {
                            Button(role: .destructive) {
                                showingClosingAlert = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Cerrar sesión")
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Hola, \(model.user.nickname).")
            .sheet(isPresented: $showingEditUser) {
                EditUserPasswordView()
            }
            .alert("¿Seguro que quieres cerrar la sesión?", isPresented: $showingClosingAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar", role: .destructive) {
                    isUnlocked = false
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onChange(of: inputImage) { newValue in
                loadImage()
                if let newValue {
                    saveJpg(newValue, title: model.user.nickname)
                }
            }
            .onAppear {
                let name = imageCoverName(from: model.user.nickname)
                image = getUserImage(from: name)
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
                    model.isBiometricsAllowed = true
                } else {
                    model.isBiometricsAllowed = false
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
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func removeUserImage() {
        let name = imageCoverName(from: model.user.nickname)
        if let path = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
            try? FileManager.default.removeItem(at: path)
        }
    }
}

struct UserMainView_Previews: PreviewProvider {
    static var previews: some View {
        UserMainView(isUnlocked: .constant(true))
            .environmentObject(UserViewModel())
    }
}
