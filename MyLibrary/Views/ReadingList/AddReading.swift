//
//  AddReading.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/3/22.
//

import SwiftUI
import UIKit

struct AddReading: View {
    @EnvironmentObject var model: NowReadingModel
    @Environment(\.dismiss) var dismiss
    
    @State var bookTitle: String
    @State private var firstPage: Int = 0
    @State private var lastPage: Int = 0
    @State var synopsis: String
    @State var formatt: Formatt
    @State private var image: Image?
    @State private var inputImage: UIImage?
    
    var isDisabled: Bool {
        guard bookTitle.isEmpty || firstPage == 0 || lastPage == 0 || firstPage >= lastPage ||
                synopsis.isEmpty else { return false }
        return true
    }
    
    @State private var showingSearchResults = false
    @State private var showingSearchAlert = false
    @State private var searchResultsTitle = ""
    @State private var searchResultsMessage = ""
    @State private var searchResults = 0
    @State private var searchArray = [String]()
    
    @State private var showingImageSelector = false
    @State private var showingImagePicker = false
    @State private var showingCameraPicker = false
    @State private var showingProgressView = false
    @State private var downloadError = ""
    
    var body: some View {
        Form {
            Section {
                Picker("Formato", selection: $formatt) {
                    ForEach(Formatt.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                TextField("Título del libro", text: $bookTitle)
                    .onSubmit { searchForExistingData(formatt, bookTitle) }
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
                    TextField("Página inicial", value: $lastPage, format: .number)
                        .multilineTextAlignment(.trailing)
                }
            }
            .keyboardType(.numberPad)
            
            Section("Resumen") {
                TextEditor(text: $synopsis)
                    .frame(width: 350, height: 200)
                VStack {
                    Button("Añadir portada") {
                        showingImageSelector = true
                    }
                    .buttonStyle(.borderless)
                    
                    
                    if showingProgressView {
                        ProgressView()
                            .frame(width: 120, height: 120)
                    } else {
                        ZStack {
                            if let image = image {
                                image
                                    .resizable()
                                    .frame(width: 100, height: 140)
                            } else {
                                Image(systemName: "questionmark.diamond")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                            }
                            Text(downloadError)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Nueva lectura")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar", role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Guardar") {
                    let newBook = NowReading(bookTitle: bookTitle, firstPage: firstPage, lastPage: lastPage, synopsis: synopsis, formatt: formatt, isOnReading: false, isFinished: false, sessions: [])
                    model.waitingList.append(newBook)
                    if let inputImage = inputImage {
                        saveJpg(inputImage, title: bookTitle)
                    }
                    dismiss()
                }
                .disabled(isDisabled)
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
                   bookTitle = data
                }
            }
        } message: {
            Text(searchResultsMessage)
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
            .disabled(bookTitle.isEmpty || formatt == .kindle)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .sheet(isPresented: $showingCameraPicker) {
            CameraPicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage() }
        .disableAutocorrection(true)
    }
    
    func searchForExistingData(_ formatt: Formatt, _ text: String) {
        searchResults = model.compareExistingBook(formatt: formatt, text: text).num
        searchArray = model.compareExistingBook(formatt: formatt, text: text).datas
        
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
            bookTitle = searchArray.first!
            return
        case 0:
            searchResultsTitle = "No se han encontrado coincidencias."
            searchResultsMessage = "Pulsa para continuar."
        default: ()
        }
        
        showingSearchAlert = true
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
                    downloadError = "No se encuentra la imagen"
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        print(response.statusCode.description)
                        image = Image(systemName: "exclamationmark.triangle")
                        downloadError = "No se encuentra la imagen"
                    }
                }
                if let data {
                    if data.count > 1000 {
                        inputImage = UIImage(data: data)
                        downloadError = ""
                    } else {
                        image = Image(systemName: "exclamationmark.triangle")
                        downloadError = "No se encuentra la imagen"
                    }
                }
            }.resume()
        } else {
            image = Image(systemName: "exclamationmark.triangle")
            downloadError = "No se encuentra la imagen"
        }
    }
}

struct AddReading_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddReading(bookTitle: "", synopsis: "", formatt: .paper)
                .environmentObject(NowReadingModel())
        }
    }
}
