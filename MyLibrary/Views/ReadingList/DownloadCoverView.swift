//
//  DownloadCoverView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/5/23.
//

import SwiftUI

struct DownloadCoverView: View {
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.adaptive(minimum: 90))]
    @Binding var selectedImage: UIImage?
    @State private var resultImages = [UIImage]()
    
    let pickerTitles = ["ISBN", "Título", "Autor"]
    @State private var pickerSelection = 0
    @State private var searchText = ""
    
    @State private var showingResults = false
    @State private var showingProgressView = false
    @State private var showingScaledImage = false
    @State private var imageToZoomIn = UIImage()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        Picker("Búsqueda por", selection: $pickerSelection) {
                            ForEach(pickerTitles.indices, id:\.self) { index in
                                Text(pickerTitles[index])
                            }
                        }
                        .pickerStyle(.segmented)
                        TextField("Escribe el ISBN, título o autor a buscar", text: $searchText)
                    }
                    Section {
                        Button {
                            showingResults = true
                            downloadCoverFromAPI()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Buscar")
                                Spacer()
                            }
                        }
                    }
                    if showingResults {
                        Section {
                            if showingProgressView {
                                ProgressView()
                            } else {
                                ScrollView {
                                    LazyVGrid(columns: columns) {
                                        ForEach(resultImages, id: \.self) { uiimage in
                                            Image(uiImage: uiimage)
                                                .resizable()
                                                .frame(width: 90, height: 120)
                                                .onTapGesture {
                                                    withAnimation(.easeIn) {
                                                        imageToZoomIn = uiimage
                                                        showingScaledImage = true
                                                    }
                                                }
                                                .onLongPressGesture {
                                                    selectedImage = uiimage
                                                    dismiss()
                                                }
                                        }
                                    }
                                }
                            }
                        } header: {
                            Text("Toca la imagen para ampliarla y mantenla pulsada para seleccionarla")
                        }
                    }
                }
                
                if showingScaledImage {
                    VStack(spacing: 5) {
                        Text("Toca la imagen para ocultarla")
                            .foregroundColor(.secondary)
                        Image(uiImage: imageToZoomIn)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                showingScaledImage = false
                            }
                        Spacer()
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .navigationTitle("Descarga la portada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
    
    func downloadCoverFromAPI() {
        // Tipos de datos de la API
        struct ApiData: Codable {
            let items: [Item]
        }
        struct Item: Codable {
            let volumeInfo: VolumeInfo
        }
        struct VolumeInfo: Codable {
            let imageLinks: ImageLinks?
        }
        struct ImageLinks: Codable {
            let thumbnail: String
        }
        
        let errorImage = UIImage(systemName: "exclamationmark.triangle")!
        var basicUrl = "https://www.googleapis.com/books/v1/volumes?q="
        
        resultImages = []
        showingProgressView = true
        
        let noSpacesText = searchText.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        if pickerSelection == 0 {
            // Búsqueda por ISBN
            basicUrl += "isbn:\(noSpacesText)"
        } else if pickerSelection == 1 {
            // Búsqueda por título
            basicUrl += "intitle:\(noSpacesText)&printType=books&orderBy=newest&maxResults=40"
        } else {
            // Búsqueda por autor
            basicUrl += "inauthor:\(noSpacesText)&printType=books&orderBy=newest&maxResults=40"
        }
        let url = URL(string: basicUrl)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            showingProgressView = false
            if error != nil {
                print(error!.localizedDescription)
                resultImages = [errorImage]
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(response.statusCode.description)
                    resultImages = [errorImage]
                }
            }
            if let data, let decoded = try? JSONDecoder().decode(ApiData.self, from: data) {
                for item in decoded.items {
                    guard let stringUrl = item.volumeInfo.imageLinks?.thumbnail else { continue }
                    // Sustituir http por https
                    let httpsUrl = "https" + stringUrl.dropFirst(4)
                    let imageUrl = URL(string: httpsUrl)!
                    URLSession.shared.dataTask(with: imageUrl) { imageData, response, error in
                        if error != nil {
                            print(error!.localizedDescription)
                            resultImages.append(errorImage)
                        }
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode != 200 {
                                print(response.statusCode.description)
                                resultImages.append(errorImage)
                            }
                        }
                        if let imageData, let decodedImage = UIImage(data: imageData) {
                            resultImages.append(decodedImage)
                        }
                    }.resume()
                }
            } else {
                resultImages = [errorImage]
            }
        }.resume()
    }
}

struct DownloadCoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DownloadCoverView(selectedImage: .constant(UIImage(named: "cover001")))
        }
    }
}
