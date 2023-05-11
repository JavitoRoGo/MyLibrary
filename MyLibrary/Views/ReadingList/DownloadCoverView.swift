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
    
    var body: some View {
        NavigationStack {
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
                                                selectedImage = uiimage
                                                dismiss()
                                            }
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Pulsa sobre la portada para seleccionarla")
                    }
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
            basicUrl += "intitle:\(noSpacesText)&printType=books&orderBy=newest&maxResults=20"
        } else {
            // Búsqueda por autor
            basicUrl += "inauthor:\(noSpacesText)&printType=books&orderBy=newest&maxResults=20"
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
                    let imageUrl = URL(string: stringUrl)!
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
