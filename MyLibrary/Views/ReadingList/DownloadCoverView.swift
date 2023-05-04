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
    let errorImage = UIImage(systemName: "exclamationmark.triangle")!
    @Binding var selectedImage: UIImage?
    @State private var resultImages = [UIImage]()
    
    let pickerTitles = ["Título", "Autor", "ISBN"]
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
                    TextField("Escribe aquí el título, autor o ISBN", text: $searchText)
                }
                Section {
                    Button {
                        showingResults = true
                        downloadCover()
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
                        Text("Pulsa la portada para seleccionarla")
                    }
                }
            }
            .navigationTitle("Descarga la portada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
    
    func downloadCover() {
        showingProgressView = true
        
        if pickerSelection == 0 {
            let searchNoSpaces = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let titleUrl = URL(string: "https://openlibrary.org/search.json?title=\(searchNoSpaces)&fields=isbn.json")!
            URLSession.shared.dataTask(with: titleUrl) { data, response, error in
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
                if let data {
                    //decodificar los datos para obtener el isbn y buscar la portada con eso
                }
            }.resume()
        } else if pickerSelection == 1 {
            
        } else {
            if searchText.contains(" ") {
                showingProgressView = false
                resultImages = [errorImage]
            } else {
                URLSession.shared.dataTask(with: URL(string: "https://covers.openlibrary.org/b/isbn/\(searchText)-L.jpg")!) { data, response, error in
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
                    if let data, let uiimage = UIImage(data: data) {
                        if data.count > 1000 {
                            resultImages = [uiimage]
                        } else {
                            resultImages = [errorImage]
                        }
                    } else {
                        resultImages = [errorImage]
                    }
                }.resume()
            }
        }
    }
}

struct DownloadCoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DownloadCoverView(selectedImage: .constant(UIImage(named: "cover001")))
        }
    }
}
