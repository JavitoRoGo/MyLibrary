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
    @EnvironmentObject var manager: LocationManager
    @Environment(\.dismiss) var dismiss
    
    @Binding var book: NowReading
    
    @State private var bookTitle: String = ""
    @State private var firstPage: Int = 0
    @State private var lastPage: Int = 0
    @State private var synopsis: String = ""
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var comment: String = ""
    @State private var location: RDLocation?
    
    @State private var showingImageSelector = false
    @State private var showingImagePicker = false
    @State private var showingCameraPicker = false
    @State private var showingProgressView = false
    @State private var showingMapSelection = false
    var coverButtonTitle: String {
        let uiImage = UIImage(systemName: "questionmark")!
        if inputImage == uiImage {
            return "Añadir portada"
        }
        return "Cambiar portada"
    }
    
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
                        
                        if showingProgressView {
                            ProgressView()
                                .frame(width: 120, height: 120)
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
        .navigationTitle("Editar...")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar", role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Modificar") {
                    let editedBook = NowReading(bookTitle: bookTitle, firstPage: firstPage, lastPage: lastPage, synopsis: synopsis, formatt: book.formatt, isOnReading: book.isOnReading, isFinished: book.isFinished, sessions: book.sessions, comment: comment.isEmpty ? nil : comment, location: location)
                    if let index = model.readingList.firstIndex(of: book) {
                        model.readingList[index] = editedBook
                        book = editedBook
                    }
                    if let index = model.waitingList.firstIndex(of: book) {
                        model.waitingList[index] = editedBook
                        book = editedBook
                    }
                    if let inputImage = inputImage {
                        saveJpg(inputImage, title: bookTitle)
                    }
                    dismiss()
                }
            }
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
                downloadCover()
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
        .onAppear {
            loadData()
            inputImage = getCoverImage(from: imageCoverName(from: book.bookTitle))
                image = Image(uiImage: inputImage!)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .disableAutocorrection(true)
    }
    
    func loadData() {
        bookTitle = book.bookTitle
        firstPage = book.firstPage
        lastPage = book.lastPage
        synopsis = book.synopsis
        if let comment = book.comment {
            self.comment = comment
        }
        location = book.location
    }
        
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func downloadCover() {
        if let book = BooksModel().books.filter({ $0.bookTitle == bookTitle }).first {
            showingProgressView.toggle()
            let isbnArray = [book.isbn1, book.isbn2, book.isbn3, book.isbn4, book.isbn5]
            let stringisbn = isbnArray.map{ String($0) }.reduce("",+)
            let isbn = Int(stringisbn)!
            
            URLSession.shared.dataTask(with: URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg")!) { data, response, error in
                showingProgressView.toggle()
                if error != nil {
                    print(error!.localizedDescription)
                    image = Image(systemName: "exclamationmark.triangle")
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        print(response.statusCode.description)
                        image = Image(systemName: "exclamationmark.triangle")
                    }
                }
                if let data {
                    if data.count > 1000 {
                        inputImage = UIImage(data: data)
                    } else {
                        image = Image(systemName: "exclamationmark.triangle")
                    }
                }
            }.resume()
        } else {
            image = Image(systemName: "exclamationmark.triangle")
        }
    }
}

struct ActualReadingEdit_Previews: PreviewProvider {
    static let example = NowReading.example[0]
    
    static var previews: some View {
        NavigationView {
            ActualReadingEdit(book: .constant(example))
                .environmentObject(NowReadingModel())
                .environmentObject(LocationManager())
        }
    }
}
