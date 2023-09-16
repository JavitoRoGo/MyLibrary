//
//  BookEditingExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension BookEditing {
    struct BookEditingModifier: ViewModifier {
        @EnvironmentObject var model: UserViewModel
        @Environment(\.dismiss) var dismiss
		
        @Binding var book: Books
        @Binding var showingAlert: Bool
        @Binding var showingAddWaitingList: Bool
        @Binding var isOnWaitingList: Bool
		
		@Binding var showingCoverSelection: Bool
		@Binding var showingImagePicker: Bool
		@Binding var showingCameraPicker: Bool
		@Binding var showingDownloadPage: Bool
		@Binding var inputImage: UIImage?
		
        let newBookTitle: String
        let newStatus: ReadingStatus
        let newOwner: String
        let newPlace: String
        let newSynopsis: String
        
        func body(content: Content) -> some View {
            content
				.navigationTitle("Editar...")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancelar") { dismiss() }
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Modificar") { showingAlert = true }
					}
				}
				.confirmationDialog("Selecciona una opción para la portada:", isPresented: $showingCoverSelection, titleVisibility: .visible) {
					Button("Cancelar", role: .cancel) { }
					Button("Seleccionar foto") {
						showingImagePicker = true
					}
					Button("Hacer foto") {
						showingCameraPicker = true
					}
					Button("Descargar imagen") {
						showingDownloadPage = true
					}
				}
				.sheet(isPresented: $showingImagePicker) {
					ImagePicker(image: $inputImage)
				}
				.sheet(isPresented: $showingCameraPicker) {
					CameraPicker(image: $inputImage)
				}
				.sheet(isPresented: $showingDownloadPage) {
					DownloadCoverView(selectedImage: $inputImage)
				}
                .alert("Se va a modificar este registro.", isPresented: $showingAlert) {
                    Button("No", role: .cancel) { }
                    Button("Sí") {
                        book.bookTitle = newBookTitle
                        book.status = newStatus
                        book.owner = newOwner
                        book.place = newPlace
                        if newPlace == soldText || newPlace == donatedText {
                            book.isActive = false
                        }
						if let inputImage {
							let newCover = imageCoverName(from: book.bookTitle)
							book.cover = newCover
							saveJpg(inputImage, title: newCover)
						} else {
							book.cover = nil
						}
                        book.synopsis = newSynopsis
                        dismiss()
                    }
                } message: {
                    Text("¿Deseas guardar los nuevos datos?")
                }
                .sheet(isPresented: $showingAddWaitingList) {
                    NavigationView {
                        AddReading(bookTitle: newBookTitle, synopsis: newSynopsis, formatt: .paper)
                    }
                }
                .onAppear {
					isOnWaitingList = model.user.nowReading.contains(where: { $0.bookTitle == book.bookTitle }) ||
					model.user.nowWaiting.contains(where: { $0.bookTitle == book.bookTitle })
					if let cover = book.cover {
						inputImage = getCoverImage(from: cover)
					}
                }
        }
    }
}
