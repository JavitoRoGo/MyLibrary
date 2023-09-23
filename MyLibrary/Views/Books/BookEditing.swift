//
//  BookEditing.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 31/12/21.
//

import SwiftUI

struct BookEditing: View {
    @EnvironmentObject var model: GlobalViewModel
    
    @Binding var book: Books
    @State var newBookTitle: String
    @State var newStatus: ReadingStatus
    @State var newOwner: String
    @State var newPlace: String
    @State var newSynopsis: String
    
    @State var showingAlert = false
    @State var showingAddWaitingList = false
    @State var isOnWaitingList = false
	
	@State var showingCoverSelection = false
	@State var showingImagePicker = false
	@State var showingCameraPicker = false
	@State var showingDownloadPage = false
	@State var inputImage: UIImage?
    
    var body: some View {
        NavigationStack {
			VStack {
				Form {
					Section {
						VStack(alignment: .leading) {
							Text("Título:")
								.font(.subheadline)
							TextField(book.bookTitle, text: $newBookTitle)
								.font(.headline)
								.disableAutocorrection(true)
						}
					}
					
					pickers
					
					Section {
						TextEditor(text: $newSynopsis)
							.frame(height: 150)
					}
					
					Section {
						if newStatus == .notRead || newStatus == .reading || newStatus == .waiting {
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
					}
				}
				
				imageSelector
			}
			.modifier(BookEditingModifier(book: $book, showingAlert: $showingAlert, showingAddWaitingList: $showingAddWaitingList, isOnWaitingList: $isOnWaitingList, showingCoverSelection: $showingCoverSelection, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingDownloadPage: $showingDownloadPage, inputImage: $inputImage, newBookTitle: newBookTitle, newStatus: newStatus, newOwner: newOwner, newPlace: newPlace, newSynopsis: newSynopsis))
        }
    }
}

struct BookEditing_Previews: PreviewProvider {
    static var previews: some View {
        BookEditing(book: .constant(Books.dataTest), newBookTitle: "Título de prueba", newStatus: .notRead, newOwner: "Yo", newPlace: "A1", newSynopsis: "Resumen de prueba.")
			.environmentObject(GlobalViewModel.preview)
    }
}
