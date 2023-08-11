//
//  AddReadingExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension AddReading {
	var isDisabled: Bool {
		guard bookTitle.isEmpty || firstPage == 0 || lastPage == 0 || firstPage >= lastPage ||
				synopsis.isEmpty else { return false }
		return true
	}
	
	func searchForExistingData(_ formatt: Formatt, _ text: String) {
		searchResults = model.compareExistingBook(formatt: formatt, text: text).num
		searchArray = model.compareExistingBook(formatt: formatt, text: text).datas
		
		switch searchResults {
			case 6...:
				searchResultsTitle = "Se han encontrado \(searchResults) coincidencias."
				searchResultsMessage = "Realiza una nueva búsqueda para acotar los resultados."
			case 2...5:
				searchResultsTitle = "\(searchResults) coincidencias."
				searchResultsMessage = "Elige un resultado:"
				showingSearchResults = true
				return
			case 1:
				bookTitle = searchArray.first!
				return
			case 0:
				searchResultsTitle = "No se han encontrado coincidencias."
				searchResultsMessage = "Pulsa para continuar."
			default: ()
		}
		
		showingSearchAlert = true
	}
	
	func loadImage() {
		guard let inputImage = inputImage else { return }
		image = Image(uiImage: inputImage)
	}
	
	struct AddReadingModifier: ViewModifier {
		@Binding var bookTitle: String
		@Binding var inputImage: UIImage?
		
		@Binding var showingSearchResults: Bool
		@Binding var showingSearchAlert: Bool
		@Binding var showingImageSelector: Bool
		@Binding var showingImagePicker: Bool
		@Binding var showingCameraPicker: Bool
		@Binding var showingDownloadPage: Bool
		
		let searchResultsTitle: String
		let searchResultsMessage: String
		let searchArray: [String]
		
		func body(content: Content) -> some View {
			content
				.autocorrectionDisabled()
				.navigationTitle("Nueva lectura")
				.navigationBarTitleDisplayMode(.inline)
				.alert(searchResultsTitle, isPresented: $showingSearchAlert) {
					Button("Aceptar") { }
				} message: {
					Text(searchResultsMessage)
				}
				.confirmationDialog(searchResultsTitle, isPresented: $showingSearchResults, titleVisibility: .visible) {
					Button("Cancelar", role: .cancel) { }
					ForEach(searchArray, id: \.self) { data in
						Button(data) {
							bookTitle = data
						}
					}
				} message: {
					Text(searchResultsMessage)
				}
				.confirmationDialog("Selecciona una opción para la portada:", isPresented: $showingImageSelector, titleVisibility: .visible) {
					Button("Canclear", role: .cancel) { }
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
		}
	}
}
