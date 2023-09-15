//
//  EBookEditView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/9/23.
//

import SwiftUI

struct EBookEditView: View {
	@EnvironmentObject var model: UserViewModel
	@Environment(\.dismiss) var dismiss
	
	@Binding var ebook: EBooks
	@State var newStatus: ReadingStatus
	@State var showingAddWaitingList = false
	@State var isOnWaitingList = false
	
	@State var showingCoverSelection = false
	@State var showingImagePicker = false
	@State var showingCameraPicker = false
	@State var showingDownloadPage = false
	@State var inputImage: UIImage?
	
	var body: some View {
		NavigationStack {
			VStack(alignment: .center, spacing: 25) {
				Text("Selecciona el nuevo estado")
				Picker("Estado", selection: $newStatus) {
					ForEach(ReadingStatus.allCases, id: \.self) {
						Text($0.rawValue)
					}
				}
				.pickerStyle(.wheel)
				
				VStack(alignment: .center, spacing: 15) {
					Button {
						showingCoverSelection = true
					} label: {
						if inputImage != nil {
							Text("Cambiar portada")
						} else {
							Text("Añadir portada")
						}
					}
					.buttonStyle(.borderedProminent)
					
					if let inputImage {
						HStack {
							Image(uiImage: inputImage)
								.resizable()
								.scaledToFit()
								.frame(height: 150)
							Button {
								self.inputImage = nil
								ebook.cover = nil
							} label: {
								Image(systemName: "xmark.circle")
									.foregroundColor(.secondary)
							}
						}
						.offset(x: 18)
					}
				}
				
				if newStatus == .notRead || newStatus == .reading || newStatus == .waiting {
					VStack {
						HStack {
							Text("¿Está en la lista de lectura?")
							Spacer()
							Image(systemName: isOnWaitingList ? "star.fill" : "star")
								.foregroundColor(isOnWaitingList ? .yellow : .gray.opacity(0.8))
						}
						Toggle("Añadir a la lista de lectura", isOn: $showingAddWaitingList)
							.foregroundColor(isOnWaitingList ? .secondary : .primary)
							.disabled(isOnWaitingList)
					}
					.padding(.horizontal)
				}
				Spacer()
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Cancelar") {
						dismiss()
					}
				}
				ToolbarItem(placement: .navigationBarTrailing) {
					Button("Modificar") {
						ebook.status = newStatus
						if let inputImage {
							// Añadir pequeño retardo para que grabe bien
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
								let newCover = imageCoverName(from: ebook.bookTitle)
								ebook.cover = newCover
								saveJpg(inputImage, title: newCover)
							}
						}
						dismiss()
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
			.sheet(isPresented: $showingAddWaitingList) {
				NavigationView {
					AddReading(bookTitle: ebook.bookTitle, synopsis: ebook.synopsis ?? "Sinopsis no disponible.", formatt: .kindle)
				}
			}
			.onAppear {
				isOnWaitingList = model.user.nowReading.contains(where: { $0.bookTitle == ebook.bookTitle }) ||
				model.user.nowWaiting.contains(where: { $0.bookTitle == ebook.bookTitle })
				if let cover = ebook.cover {
					inputImage = getCoverImage(from: cover)
				}
			}
		}
	}
}

struct EBookEditView_Previews: PreviewProvider {
    static var previews: some View {
		EBookEditView(ebook: .constant(EBooks.dataTest), newStatus: .reading)
			.environmentObject(UserViewModel())
    }
}
