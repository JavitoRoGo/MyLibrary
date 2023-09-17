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
        let name = imageCoverName(from: model.user.nickname)
        if let path = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
            try? FileManager.default.removeItem(at: path)
        }
    }
    
    struct UserMainViewModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
		
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
				.navigationTitle("Hola, \(model.user.nickname).")
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
