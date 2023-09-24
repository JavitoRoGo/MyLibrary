//
//  UserMainViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/8/23.
//

import SwiftUI

extension UserMainView {
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func removeUserImage() {
		let name = imageCoverName(from: model.userLogic.user.nickname)
		let path = URL.documentsDirectory.appending(path: "\(name).jpg")
		try? FileManager.default.removeItem(at: path)
    }
    
    struct UserMainViewModifier: ViewModifier {
		@Environment(GlobalViewModel.self) var model
		
        @Binding var showingClosingAlert: Bool
        @Binding var isUnlocked: Bool
		
        @Binding var showingSelectorPicker: Bool
        @Binding var showingImagePicker: Bool
        @Binding var showingCameraPicker: Bool
		@Binding var image: Image?
        @Binding var inputImage: UIImage?
		
		let loadImage: () -> Void
        
        func body(content: Content) -> some View {
            content
				.navigationTitle("Hola, \(model.userLogic.user.nickname).")
				.onChange(of: inputImage, initial: true) { _, newValue in
					loadImage()
					if let newValue {
						saveJpg(newValue, title: model.userLogic.user.nickname)
					}
				}
				.onAppear {
					let name = imageCoverName(from: model.userLogic.user.nickname)
					image = getUserImage(from: name)
				}
                .confirmationDialog("Elige una opción para la imagen:", isPresented: $showingSelectorPicker) {
                    Button("Canclear", role: .cancel) { }
                    Button("Seleccionar foto") {
                        showingImagePicker = true
                    }
                    Button("Hacer foto") {
                        showingCameraPicker = true
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(image: $inputImage)
                }
                .sheet(isPresented: $showingCameraPicker) {
                    CameraPicker(image: $inputImage)
                }
				.alert("¿Seguro que quieres cerrar la sesión?", isPresented: $showingClosingAlert) {
					Button("Cancelar", role: .cancel) { }
					Button("Cerrar", role: .destructive) {
						isUnlocked = false
					}
				}
        }
    }
}
