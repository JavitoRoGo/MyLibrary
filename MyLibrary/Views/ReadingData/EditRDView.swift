//
//  EditRDView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/11/22.
//

import SwiftUI

struct EditRDView: View {
    @Environment(GlobalViewModel.self) var model
    @Environment(\.dismiss) var dismiss
    
    @State private var rating = 0
    @State private var comment = ""
    @State private var location: RDLocation?
    @State private var showingLocation = false
    @Binding var book: ReadingData
	
	let textLimit = 120
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .center, spacing: 30) {
                    Text("Cambia tu valoración del libro:")
                        .font(.title2)
					if let uiimage = getCoverImage(from: book.cover) {
						Image(uiImage: uiimage)
							.resizable()
							.modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
					} else {
						Text(book.bookTitle)
							.modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
					}
                    RDStars(rating: $rating)
                        .font(.largeTitle)
                }
                .padding(.leading)
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
            
            Section {
                Button {
                    showingLocation = true
                } label: {
                    HStack {
                        Spacer()
                        Label("Establecer ubicación", systemImage: "location.north.circle.fill")
                        if location != nil {
                            Image(systemName: "checkmark.square.fill")
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                }
            }
            
            HStack(spacing: 30) {
                Button("Volver") {
                    dismiss()
                }
				.fixedSize()
                .padding(.leading, 40)
                Spacer()
                Button("Guardar") {
                    saveChanges()
                }
				.fixedSize()
                .padding(.trailing, 40)
            }
            .buttonStyle(.bordered)
        }
        .sheet(isPresented: $showingLocation) {
            EditRDMapView(location: $location)
        }
        .onAppear {
            rating = book.rating
            if let comment = book.comment {
                self.comment = comment
            }
            location = book.location
        }
    }
    
    func saveChanges() {
		if let index = model.userLogic.user.readingDatas.firstIndex(of: book) {
			model.userLogic.user.readingDatas[index].rating = rating
			model.userLogic.user.readingDatas[index].comment = comment.isEmpty ? nil : comment
            if let location {
				model.userLogic.user.readingDatas[index].location = location
            }
        }
        dismiss()
    }
}

struct EditRDView_Previews: PreviewProvider {
    static var previews: some View {
        EditRDView(book: .constant(ReadingData.example[0]))
			.environment(GlobalViewModel.preview)
    }
}
