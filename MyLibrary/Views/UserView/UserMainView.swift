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
    
    @State var showingClosingAlert = false
    @State var showingEditUser = false
    
    @State var showingSelectorPicker = false
    @State var showingImagePicker = false
    @State var showingCameraPicker = false
    @State var image: Image?
    @State var inputImage: UIImage?
	
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
                                    showingSelectorPicker = true
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
                                showingSelectorPicker = true
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
						
						deleteButtons
                        
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
			.modifier(UserMainViewModifier(showingEditUser: $showingEditUser, showingClosingAlert: $showingClosingAlert, isUnlocked: $isUnlocked, showingSelectorPicker: $showingSelectorPicker, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, image: $image, inputImage: $inputImage, showingDeletingDatas: $showingDeletingDatas, showingDeletingUser: $showingDeletingUser, showingPasswordField: $showingPasswordField, showingSuccessfulDeleting: $showingSuccessfulDeleting, showingWrongPassword: $showingWrongPassword, password: $password, loadImage: loadImage, authenticateToDelete: authenticateToDelete))
        }
    }
}

struct UserMainView_Previews: PreviewProvider {
    static var previews: some View {
        UserMainView(isUnlocked: .constant(true))
            .environmentObject(UserViewModel())
    }
}
