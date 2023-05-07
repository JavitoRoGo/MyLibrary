//
//  CoverAPIHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 7/5/23.
//

import SwiftUI

// Tipos de datos que devuelve la API

private struct Titles: Decodable {
    let docs: [Doc]
}
private struct Doc: Decodable {
    let isbn: [String]?
}

// Función para recuperar los datos de la API

func downloadCoverFromAPI(selection: Int, searchText: String) async -> [UIImage] {
    let errorImage = UIImage(systemName: "exclamationmark.triangle")!
    var resultImages: [UIImage] = []
    var isSearching = true
    
    if selection == 0 {
        if searchText.contains(" ") {
            isSearching = false
            return [errorImage]
        } else {
            URLSession.shared.dataTask(with: URL(string: "https://covers.openlibrary.org/b/isbn/\(searchText)-L.jpg")!) { data, response, error in
                if error != nil {
                    print(error!.localizedDescription)
                    resultImages = [errorImage]
                    isSearching = false
                }
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        print(response.statusCode.description)
                        resultImages = [errorImage]
                        isSearching = false
                    }
                }
                if let data, let uiimage = UIImage(data: data) {
                    if data.count > 1000 {
                        resultImages = [uiimage]
                        isSearching = false
                    } else {
                        resultImages = [errorImage]
                        isSearching = false
                    }
                } else {
                    resultImages = [errorImage]
                    isSearching = false
                }
            }.resume()
        }
    } else {
        let searchNoSpaces = searchText.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let titleUrl = URL(string: "https://openlibrary.org/search.json?title=\(searchNoSpaces)&fields=isbn")!
        URLSession.shared.dataTask(with: titleUrl) { data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                resultImages = [errorImage]
                isSearching = false
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(response.statusCode.description)
                    resultImages = [errorImage]
                    isSearching = false
                }
            }
            if let data {
                guard let titles = try? JSONDecoder().decode(Titles.self, from: data) else {
                    print("No decodifica")
                    resultImages = [errorImage]
                    isSearching = false
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
                            isSearching = false
                        }
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode != 200 {
                                print(response.statusCode.description)
                                resultImages = [errorImage]
                                isSearching = false
                            }
                        }
                        if let data, let uiimage = UIImage(data: data) {
                            if data.count > 1000 {
                                resultImages.append(uiimage)
                                isSearching = false
                            } else {
                                resultImages.append(errorImage)
                                isSearching = false
                            }
                        } else {
                            resultImages = [errorImage]
                            isSearching = false
                        }
                    }.resume()
                }
            }
        }.resume()
    }
    while isSearching {
        sleep(1)
    }
    return resultImages
}
