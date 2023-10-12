//
//  ActualReadingEdit.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/5/22.
//

import MapKit
import SwiftUI

struct ActualReadingEdit: View {
    @Environment(GlobalViewModel.self) var model
    
    @Binding var book: NowReading
    
    @State var bookTitle: String = ""
    @State var firstPage: Int = 0
    @State var lastPage: Int = 0
    @State var synopsis: String = ""
    @State var image: Image?
    @State var inputImage: UIImage?
    @State var comment: String = ""
    @State var location: RDLocation?
    @State var isbn: String = ""
    
    @State var showingImageSelector = false
    @State var showingImagePicker = false
    @State var showingCameraPicker = false
    @State var showingDownloadedImage = false
    @State var showingMapSelection = false
    
	var body: some View {
		Form {
            Section {
                TextField(book.bookTitle, text: $bookTitle)
            }
            
            Section {
                HStack {
                    Text("Página inicial")
                    Spacer()
                    TextField("Página inicial", value: $firstPage, format: .number)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Página final")
                    Spacer()
                    TextField("Página final", value: $lastPage, format: .number)
                        .multilineTextAlignment(.trailing)
                }
            }
            .keyboardType(.numberPad)
            
            Section("Resumen") {
                TextEditor(text: $synopsis)
                    .frame(width: 350, height: 150)
                HStack {
					VStack {
						Button(coverButtonTitle) {
							showingImageSelector = true
						}
						
						if let image = image {
							image
								.resizable()
								.frame(width: 100, height: 140)
								.clipShape(.rect(cornerRadius: 15))
						} else {
							Image(systemName: "questionmark.diamond")
								.resizable()
								.frame(width: 140, height: 140)
						}
					}
                    Spacer()
                    VStack {
                        Button("Ubicación") {
                            showingMapSelection = true
                        }
                        VStack {
                            if location != nil {
								Image(.map)
									.resizable()
									.clipShape(.rect(cornerRadius: 15))
							} else {
								Rectangle()
									.stroke(lineWidth: 0)
							}
                        }
						.frame(width: 150, height: 140)
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Section("Comentarios al libro") {
                TextEditor(text: $comment)
                    .frame(width: 350, height: 150)
            }
        }
		.modifier(AREditModifier(book: $book, showingImageSelector: $showingImageSelector, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingMapSelection: $showingMapSelection, showingDownloadedImage: $showingDownloadedImage, inputImage: $inputImage, location: $location, bookTitle: bookTitle, loadData: loadData, loadImage: loadImage, createEditedBook: createEditedBook))
    }
}

struct ActualReadingEdit_Previews: PreviewProvider {
    static let example = NowReading.dataTest
    
    static var previews: some View {
        NavigationView {
            ActualReadingEdit(book: .constant(example))
				.environment(GlobalViewModel.preview)
        }
    }
}
