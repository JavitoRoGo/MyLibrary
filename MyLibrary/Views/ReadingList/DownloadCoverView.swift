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
    
    let pickerTitles = ["ISBN", "Título"]
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
        let errorImage = UIImage(systemName: "exclamationmark.triangle")!
        resultImages = []
        showingProgressView = true
        
        if pickerSelection == 0 {
            // Búsqueda por ISBN
            if searchText.contains(" ") {
                resultImages = [errorImage]
                showingProgressView = false
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
        } else {
            // Búsqueda por título
            let searchNoSpaces = searchText.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let titleUrl = URL(string: "https://openlibrary.org/search.json?title=\(searchNoSpaces)&fields=isbn")!
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
                    struct Titles: Decodable {
                        let docs: [Doc]
                    }
                    struct Doc: Decodable {
                        let isbn: [String]?
                    }

                   guard let titles = try? JSONDecoder().decode(Titles.self, from: data) else {
                        print("No decodifica")
                        resultImages = [errorImage]
                        return
                    }
                    var isbnArray = [String]()
                    titles.docs.forEach { doc in
                        if let array = doc.isbn {
                            for isbn in array where isbn.hasPrefix("97884") {
                                isbnArray.append(isbn)
                            }
                        }
                    }
                    isbnArray.forEach { isbn in
                        URLSession.shared.dataTask(with: URL(string: "https://covers.openlibrary.org/b/isbn/\(isbn)-L.jpg")!) { data, response, error in
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
                                    resultImages.append(uiimage)
                                } else {
                                    resultImages.append(errorImage)
                                }
                            } else {
                                resultImages = [errorImage]
                            }
                        }.resume()
                    }
                }
            }.resume()
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
