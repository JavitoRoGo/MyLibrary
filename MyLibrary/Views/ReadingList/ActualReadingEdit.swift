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
	
	let textLimit = 120
    
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
            
            Section {
                TextEditor(text: $comment)
                    .frame(width: 350, height: 120)
					.onChange(of: comment) {
						comment = String(comment.prefix(textLimit))
					}
			} header: {
				Text("Comentarios al libro")
			} footer: {
				HStack {
					Spacer()
					Text("\(comment.count)/\(textLimit)")
						.foregroundStyle(comment.count < (textLimit*80/100) ? .secondary : comment.count < textLimit ? Color.orange : Color.red)
						.fontWeight(comment.count < textLimit ? .regular : .black)
				}
			}
        }
		.modifier(AREditModifier(book: $book, showingImageSelector: $showingImageSelector, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingMapSelection: $showingMapSelection, showingDownloadedImage: $showingDownloadedImage, inputImage: $inputImage, location: $location, bookTitle: bookTitle, loadData: loadData, loadImage: loadImage, createEditedBook: createEditedBook))
    }
}

struct ActualReadingEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
			ActualReadingEdit(book: .constant(NowReading.example[0]))
				.environment(GlobalViewModel.preview)
        }
    }
}
