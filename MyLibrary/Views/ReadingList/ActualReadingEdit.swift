//
//  ActualReadingEdit.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 15/5/22.
//

import MapKit
import SwiftUI

struct ActualReadingEdit: View {
    @EnvironmentObject var model: NowReadingModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var manager: LocationManager
    
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
                        
                        if showingDownloadedImage {
                            AsyncImage(url: URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg")) { phase in
                                if let apiImage = phase.image {
                                    apiImage
                                        .resizable()
                                        .frame(width: 100, height: 140)
                                } else if phase.error != nil {
                                    Image(systemName: "exclamationmark.triangle")
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                } else {
                                    ProgressView()
                                }
                            }
                        } else {
                            if let image = image {
                                image
                                    .resizable()
                                    .frame(width: 100, height: 140)
                            } else {
                                Image(systemName: "questionmark.diamond")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                        }
                    }
                    Spacer()
                    VStack {
                        Button("Ubicación") {
                            showingMapSelection = true
                        }
                        ZStack {
                            Rectangle()
                                .stroke(lineWidth: 0)
                                .frame(width: 180, height: 140)
                            if let location {
                                Map(coordinateRegion: $manager.region, interactionModes: .zoom, showsUserLocation: false, annotationItems: [location]) { pin in
                                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude))
                                }
                                    .frame(width: 180, height: 140)
                            }
                        }
                    }
                }
                .buttonStyle(.bordered)
            }
            
            Section("Comentarios al libro") {
                TextEditor(text: $comment)
                    .frame(width: 350, height: 150)
            }
        }
		.modifier(AREditModifier(book: $book, showingImageSelector: $showingImageSelector, showingImagePicker: $showingImagePicker, showingCameraPicker: $showingCameraPicker, showingMapSelection: $showingMapSelection, showingDownloadedImage: $showingDownloadedImage, inputImage: $inputImage, location: $location, isbn: $isbn, bookTitle: bookTitle, loadData: loadData, loadImage: loadImage, createEditedBook: createEditedBook))
    }
}

struct ActualReadingEdit_Previews: PreviewProvider {
    static let example = NowReading.example[0]
    
    static var previews: some View {
        NavigationView {
            ActualReadingEdit(book: .constant(example))
                .environmentObject(NowReadingModel())
                .environmentObject(BooksModel())
                .environmentObject(LocationManager())
        }
    }
}
