//
//  CameraPicker.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 29/4/23.
//

import SwiftUI
import UIKit

struct CameraPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.cameraFlashMode = .off
        picker.cameraCaptureMode = .photo
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
