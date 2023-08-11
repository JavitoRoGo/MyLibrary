//
//  ActualReadingEditExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension ActualReadingEdit {
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
	
	struct AREditModifier: ViewModifier {
		@EnvironmentObject var model: NowReadingModel
		@EnvironmentObject var bmodel: BooksModel
		
		@Binding var showingImageSelector: Bool
		@Binding var showingImagePicker: Bool
		@Binding var showingCameraPicker: Bool
		@Binding var showingMapSelection: Bool
		@Binding var showingDownloadedImage: Bool
		@Binding var inputImage: UIImage?
		@Binding var location: RDLocation?
		@Binding var isbn: String
		
		let book: NowReading
		let bookTitle: String
		
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
						if let book = bmodel.books.filter({ $0.bookTitle == bookTitle }).first {
							let isbnArray = [book.isbn1, book.isbn2, book.isbn3, book.isbn4, book.isbn5]
							let isbnString = isbnArray.map { String($0) }.reduce("",+)
							isbn = isbnString
						}
						
						showingDownloadedImage = true
					}
					.disabled(bookTitle.isEmpty || book.formatt == .kindle)
				}
				.sheet(isPresented: $showingImagePicker) {
					ImagePicker(image: $inputImage)
				}
				.sheet(isPresented: $showingCameraPicker) {
					CameraPicker(image: $inputImage)
				}
				.sheet(isPresented: $showingMapSelection) {
					EditRDMapView(location: $location)
				}
		}
	}
}
