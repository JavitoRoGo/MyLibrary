//
//  DownloadCoverHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 20/5/23.
//

import Foundation
import UIKit

// Tipos de datos de la API de Google Books (en desuso por necesitar API key)
//struct ApiData: Codable {
//	let items: [Item]
//}
//struct Item: Codable {
//	let volumeInfo: VolumeInfo
//}
//struct VolumeInfo: Codable {
//	let imageLinks: ImageLinks?
//}
//struct ImageLinks: Codable {
//	let thumbnail: String
//}

// Función comentada para usar la alternativa con booksTask y creación de tareas

//func fetchApiData(url: URL) async -> ApiData {
//    do {
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoded = try JSONDecoder().decode(ApiData.self, from: data)
//        return decoded
//    } catch {
//        return ApiData(items: [])
//    }
//}

// Función comentada para usar la mejor alternativa de creación de TaskGroup

//func fetchCover(from stringUrl: String) async -> UIImage {
//    let errorImage = UIImage(systemName: "exclamationmark.triangle")!
//    let httpsUrl = stringUrl.replacingOccurrences(of: "http", with: "https")
//    let imageUrl = URL(string: httpsUrl)!
//    do {
//        let (data, _) = try await URLSession.shared.data(from: imageUrl)
//        if let decodedImage = UIImage(data: data) {
//            return decodedImage
//        } else {
//            return errorImage
//        }
//    } catch {
//        return errorImage
//    }
//}

// Función de llamada a la API de Google Books (en desuso por necesitar API key)

//func downloadCoverFromAPI(searchText: String, in selection: Int) async -> [UIImage] {
//    var basicUrl = "https://www.googleapis.com/books/v1/volumes?q="
//    let errorImage = UIImage(systemName: "exclamationmark.triangle")!
//    var images = [UIImage]()
//    
//    let noSpacesText = searchText.lowercased().replacingOccurrences(of: " ", with: "+")
//    if selection == 0 {
//        // Búsqueda por ISBN
//        basicUrl += "isbn:\(noSpacesText)"
//    } else if selection == 1 {
//        // Búsqueda por título
//        basicUrl += "\(noSpacesText)&printType=books"
//    } else {
//        // Búsqueda por autor
//        basicUrl += "inauthor:\(noSpacesText)&printType=books"
//    }
//    let url = URL(string: basicUrl)!
//    
//    let booksTask = Task { () -> ApiData in
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let decoded = try JSONDecoder().decode(ApiData.self, from: data)
//        return decoded
//    }
//    
//    do {
//        let apiData = try await booksTask.value
//        // Bucle ejecutado dentro del TaskGroup
////        for item in apiData.items {
////            guard let stringUrl = item.volumeInfo.imageLinks?.thumbnail else { continue }
////            let image = await fetchCover(from: stringUrl)
////            images.append(image)
////        }
//        images = try await withThrowingTaskGroup(of: UIImage.self) { group -> [UIImage] in
//            for item in apiData.items {
//                guard let stringUrl = item.volumeInfo.imageLinks?.thumbnail else { continue }
//                group.addTask {
//                    let httpsUrl = stringUrl.replacingOccurrences(of: "http", with: "https")
//                    let imageUrl = URL(string: httpsUrl)!
//                    let (data, _) = try await URLSession.shared.data(from: imageUrl)
//                    if let decodedImage = UIImage(data: data) {
//                        return decodedImage
//                    } else {
//                        return errorImage
//                    }
//                }
//            }
//            let fetchedImages = try await group.reduce(into: [UIImage]()) { $0.append($1) }
//            return fetchedImages
//        }
//    } catch {
//        images = []
//    }
//    
//    return images
//}


// Nueva función de descarga de Open Library

func downloadCoverFromAPI(searchText: String, in selection: Int) async -> [UIImage] {
	let errorImage = UIImage(systemName: "exclamationmark.triangle")!
	var images = [UIImage]()
	
	let encodedText = searchText
		.lowercased()
		.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
	
	var searchUrlString = "https://openlibrary.org/search.json?"
	var limit = 1
	
	switch selection {
	case 0:
		searchUrlString += "isbn=\(encodedText)"
	case 1:
		searchUrlString += "title=\(encodedText)"
		limit = 10
	default:
		searchUrlString += "author=\(encodedText)"
		limit = 50
	}
	
	guard let searchUrl = URL(string: searchUrlString) else {
		return []
	}
	
	struct SearchResponse: Codable {
		let docs: [Doc]
	}
	
	struct Doc: Codable {
		let cover_i: Int?
	}
	
	let searchTask = Task { () -> SearchResponse in
		let (data, _) = try await URLSession.shared.data(from: searchUrl)
		return try JSONDecoder().decode(SearchResponse.self, from: data)
	}
	
	do {
		let searchResponse = try await searchTask.value
		
		let docsWithCover = searchResponse.docs
			.compactMap { $0.cover_i }
			.prefix(limit)
		
		images = try await withThrowingTaskGroup(of: UIImage.self) { group -> [UIImage] in
			for coverId in docsWithCover {
				group.addTask {
					let coverUrlString = "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
					guard let coverUrl = URL(string: coverUrlString) else {
						return errorImage
					}
					let (data, _) = try await URLSession.shared.data(from: coverUrl)
					return UIImage(data: data) ?? errorImage
				}
			}
			
			return try await group.reduce(into: [UIImage]()) { $0.append($1) }
		}
		
	} catch {
		images = []
	}
	
	return images
}
