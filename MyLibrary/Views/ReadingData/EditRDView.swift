//
//  EditRDView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/11/22.
//

import SwiftUI

struct EditRDView: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var rating = 0
    @State private var comment = ""
    @State private var location: RDLocation?
    @State private var showingLocation = false
    @Binding var book: ReadingData
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .center, spacing: 30) {
                    Text("Cambia tu valoración del libro:")
                        .font(.title2)
                    Image(uiImage: getCoverImage(from: book.cover))
                        .resizable()
                        .modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
                    RDStars(rating: $rating)
                        .font(.largeTitle)
                }
                .padding(.leading)
            }
            
            Section("Comentarios al libro") {
                TextEditor(text: $comment)
                    .frame(width: 350, height: 150)
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
                .padding(.leading, 50)
                Spacer()
                Button("Guardar") {
                    saveChanges()
                }
                .padding(.trailing, 50)
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
		if let index = model.user.readingDatas.firstIndex(of: book) {
			model.user.readingDatas[index].rating = rating
			model.user.readingDatas[index].comment = comment.isEmpty ? nil : comment
            if let location {
				model.user.readingDatas[index].location = location
            }
        }
        dismiss()
    }
}

struct EditRDView_Previews: PreviewProvider {
    static var previews: some View {
        EditRDView(book: .constant(ReadingData.dataTest))
            .environmentObject(UserViewModel())
    }
}
