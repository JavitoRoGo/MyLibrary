//
//  ActualReadingEditExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension ActualReadingEdit {
	var coverButtonTitle: String {
		let uiImage = UIImage(systemName: "questionmark")!
		if inputImage == uiImage {
			return "Añadir portada"
		}
		return "Cambiar portada"
	}
	
	func loadData() {
		bookTitle = book.bookTitle
		firstPage = book.firstPage
		lastPage = book.lastPage
		synopsis = book.synopsis
		inputImage = getCoverImage(from: imageCoverName(from: book.bookTitle))
		image = Image(uiImage: inputImage!)
		if let comment = book.comment {
			self.comment = comment
		}
		location = book.location
	}
	
	func loadImage() {
		guard let inputImage = inputImage else { return }
		image = Image(uiImage: inputImage)
	}
	
	func createEditedBook() -> NowReading {
		return NowReading(bookTitle: bookTitle, firstPage: firstPage, lastPage: lastPage, synopsis: synopsis, formatt: book.formatt, isOnReading: book.isOnReading, isFinished: book.isFinished, sessions: book.sessions, comment: comment.isEmpty ? nil : comment, location: location)
	}
	
	struct AREditModifier: ViewModifier {
		@Environment(GlobalViewModel.self) var model
		@Environment(\.dismiss) var dismiss
		
		@Binding var book: NowReading
		@Binding var showingImageSelector: Bool
		@Binding var showingImagePicker: Bool
		@Binding var showingCameraPicker: Bool
		@Binding var showingMapSelection: Bool
		@Binding var showingDownloadedImage: Bool
		@Binding var inputImage: UIImage?
		@Binding var location: RDLocation?
		
		let bookTitle: String
		let loadData: () -> Void
		let loadImage: () -> Void
		let createEditedBook: () -> NowReading
		
		func body(content: Content) -> some View {
			content
				.autocorrectionDisabled()
				.navigationTitle("Editar...")
				.navigationBarTitleDisplayMode(.inline)
				.confirmationDialog("Selecciona una opción para la portada:", isPresented: $showingImageSelector, titleVisibility: .visible) {
					Button("Canclear", role: .cancel) { }
					Button("Seleccionar foto") {
						showingImagePicker = true
					}
					Button("Hacer foto") {
						showingCameraPicker = true
					}
					Button("Descargar imagen") {
						showingDownloadedImage = true
					}
				}
				.sheet(isPresented: $showingImagePicker) {
					ImagePicker(image: $inputImage)
				}
				.sheet(isPresented: $showingCameraPicker) {
					CameraPicker(image: $inputImage)
				}
				.sheet(isPresented: $showingDownloadedImage) {
					DownloadCoverView(selectedImage: $inputImage)
				}
				.sheet(isPresented: $showingMapSelection) {
					EditRDMapView(location: $location)
				}
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancelar", role: .cancel) {
							dismiss()
						}
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Modificar") {
							let editedBook = createEditedBook()
							if let index = model.userLogic.user.nowReading.firstIndex(of: book) {
								model.userLogic.user.nowReading[index] = editedBook
								book = editedBook
							}
							if let index = model.userLogic.user.nowWaiting.firstIndex(of: book) {
								model.userLogic.user.nowWaiting[index] = editedBook
								book = editedBook
							}
							if let inputImage = inputImage {
								saveJpg(inputImage, title: bookTitle)
							}
							dismiss()
						}
					}
				}
				.onAppear {
					loadData()
				}
				.onChange(of: inputImage) { _, _ in loadImage() }
		}
	}
}
