//
//  AddEBookExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension AddEBook {
	var isDisabled: Bool {
		guard newAuthor.isEmpty || newBookTitle.isEmpty || newOriginalTitle.isEmpty ||
				newYear == 0 || newPages == 0 || newOwner.isEmpty else { return false }
		return true
	}
	var newID: Int {
		model.user.ebooks.count + 1
	}
	
    func searchForExistingData(_ text: String) {
        searchResults = model.compareExistingAuthors(text: text).num
        searchArray = model.compareExistingAuthors(text: text).authors
        
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
            newAuthor = searchArray.first!
            return
        case 0:
            searchResultsTitle = "No se han encontrado coincidencias."
            searchResultsMessage = "Pulsa para continuar."
        default: ()
        }
        
        showingSearchAlert = true
    }
    
    func createNewEBook() -> EBooks {
		let cover: String?
		if let inputImage {
			cover = imageCoverName(from: newBookTitle)
			saveJpg(inputImage, title: cover!)
		} else {
			cover = nil
		}
        let newEBook = EBooks(id: newID, author: newAuthor, bookTitle: newBookTitle, originalTitle: newOriginalTitle, year: newYear, pages: newPages, price: newPrice, owner: newOwner, status: newStatus, synopsis: synopsis.isEmpty ? nil : synopsis, cover: cover)
		return newEBook
    }
    
    struct AddEBookModifier: ViewModifier {
		@EnvironmentObject var model: UserViewModel
        @Environment(\.dismiss) var dismiss
        
        @Binding var showingAddWaitingAlert: Bool
        @Binding var showingAddWaiting: Bool
        @Binding var showingSearchAlert: Bool
        @Binding var showingSearchResults: Bool
		@Binding var showingAlert: Bool
		
		@Binding var showingCoverSelection: Bool
		@Binding var showingImagePicker: Bool
		@Binding var showingCameraPicker: Bool
		@Binding var showingDownloadPage: Bool
		@Binding var inputImage: UIImage?
		
        @Binding var newAuthor: String
        
		let newID: Int
        let newBookTitle: String
        let synopsis: String
        let searchResultsTitle: String
        let searchResultsMessage: String
        let searchArray: [String]
		let createNewEBook: () -> EBooks
        
        func body(content: Content) -> some View {
            content
                .autocorrectionDisabled()
				.navigationTitle("Nuevo registro: \(newID)")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Cancelar") { dismiss() }
					}
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Añadir") {
							showingAlert = true
						}
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
                .alert("¿Deseas añadir el ebook a la lista de espera de lectura?", isPresented: $showingAddWaitingAlert) {
                    Button("No", role: .cancel) {
                        dismiss()
                    }
                    Button("Sí") {
                        showingAddWaiting = true
                    }
                }
                .sheet(isPresented: $showingAddWaiting) {
                    NavigationView {
                        AddReading(bookTitle: newBookTitle, synopsis: synopsis, formatt: .kindle)
                    }
                }
                .alert(searchResultsTitle, isPresented: $showingSearchAlert) {
                    Button("Aceptar") { }
                } message: {
                    Text(searchResultsMessage)
                }
                .confirmationDialog(searchResultsTitle, isPresented: $showingSearchResults, titleVisibility: .visible) {
                    Button("Cancelar", role: .cancel) { }
                    ForEach(searchArray, id: \.self) { data in
                        Button(data) {
                           newAuthor = data
                        }
                    }
                } message: {
                    Text(searchResultsMessage)
                }
				.alert("¿Deseas añadir el nuevo registro?", isPresented: $showingAlert) {
					Button("No", role: .cancel) { }
					Button("Sí") {
						let newEBook = createNewEBook()
						model.user.ebooks.append(newEBook)
						showingAddWaitingAlert = true
					}
				} message: {
					Text(newBookTitle)
				}
        }
    }
}
