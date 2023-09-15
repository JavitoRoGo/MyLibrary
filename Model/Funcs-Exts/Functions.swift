//
//  Functions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/4/22.
//

import Foundation
import SwiftUI

// MARK: - Funciones varias

// Funciones para icono y color según estado, y mensajes de información

func imageNameStatus(_ status: ReadingStatus) -> String {
    switch status {
    case .notRead:
        return "bookmark.slash"
    case .read:
        return "book"
    case .registered:
        return "paperclip"
    case .consulting:
        return "text.book.closed"
    case .reading:
        return "eyes"
    case .waiting:
        return "hourglass"
    }
}

func imageStatus<T: BooksProtocol>(_ book: T) -> Image {
    switch book.status {
    case .notRead:
        return Image(systemName: "bookmark.slash")
    case .read:
        return Image(systemName: "book")
    case .registered:
        return Image(systemName: "paperclip")
    case .consulting:
        return Image(systemName: "text.book.closed")
//    case .noStatus:
//        return Image(systemName: "questionmark.app")
    case .reading:
        return Image(systemName: "eyes")
    case .waiting:
        return Image(systemName: "hourglass")
    }
}

func colorStatus(_ status: ReadingStatus) -> Color {
    switch status {
    case .notRead:
        return .red
    case .read:
        return .green
    case .registered:
        return .blue
    case .consulting:
        return .brown
    case .reading:
        return .orange
    case .waiting:
        return .primary.opacity(0.8)
    }
}

func setInfoAlertFor<T: BooksProtocol>(_ book: T) -> (title: String, message: String) {
    let title: String
    var message = "Pulsa para volver."
    switch book.status {
    case .registered:
        title = "Libro leído y con registro de lectura."
        message = "Pulsa para ver los detalles."
    case .notRead:
        title = "Libro sin leer o pendiente."
    case .read:
        title = "Libro leído pero sin registro de lectura."
    case .consulting:
        title = "Libro de consulta."
//    case .noStatus:
//        title = "Libro en estado desconocido."
    case .reading:
        title = "Libro en proceso de lectura."
        message = "Pulsa para ver los detalles."
    case .waiting:
        title = "Libro en lista de espera."
    }
    return (title, message)
}


// Función para obtener n colores aleatorios
func getRandomColors() -> [Color] {
    var colors = [Color]()
    for _ in 0..<20 {
        let red = Double.random(in: 0...255)
        let green = Double.random(in: 0...255)
        let blue = Double.random(in: 0...255)
        let color = Color(red: red/255, green: green/255, blue: blue/255, opacity: 0.8)
        colors.append(color)
    }
    return colors
}


// Funciones de comparación de cada valor con la media
func compareWithMean(value: Double, mean: Double) -> (color: Color, image: String) {
    if value >= mean {
        return (Color.green, "arrow.turn.right.up")
    } else {
        return (Color.red, "arrow.turn.right.down")
    }
}


// MARK: - Función para obtener la ruta a FileManager

func getDocumentDirectory() -> URL? {
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return path.first
}


// MARK: - Funciones para la imagen de portada

// Función para crear el nombre de la imagen de portada a partir del título

func imageCoverName(from title: String) -> String {
    let charsToRemove = [" ", ",", ".", ":", ";", "?", "¿", "!", "¡", "-"]
    let charsToReplace = ["á", "é", "í", "ó", "ú", "ñ"]
    let charsToReplaceBy = ["a", "e", "i", "o", "u", "n"]
    var name = title
    for item in charsToRemove where name.contains(item) {
        name = name.replacingOccurrences(of: item, with: "", options: [.literal, .caseInsensitive], range: nil)
    }
    for (index, item) in charsToReplace.enumerated() where name.contains(item) {
        name = name.replacingOccurrences(of: item, with: charsToReplaceBy[index], options: [.literal, .caseInsensitive])
    }
    return name.lowercased()
}

func saveJpg(_ image: UIImage, title: String) {
    let name = imageCoverName(from: title)
    if let jpgData = image.jpegData(compressionQuality: 0.5),
       let path = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
        try? jpgData.write(to: path)
        print("Imagen guardada en Archivos")
        print(path.absoluteString)
    } else {
        print("No se pudo guardar la imagen")
    }
}

// Función para obtener la portada del Bundle o de Archivos
func getCoverImage(from cover: String) -> UIImage {
    var coverToShow = UIImage(systemName: "questionmark")!
    if let existingCover = UIImage(named: cover) {
        coverToShow = existingCover
    } else {
        if let file = getDocumentDirectory()?.appendingPathComponent("\(cover).jpg") {
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    let coverData = try Data(contentsOf: file)
                    if let savedCover = UIImage(data: coverData) {
                        coverToShow = savedCover
                    }
                } catch {
                    print("Error al convertir la imagen: \(error)")
                }
            }
        }
    }
    return coverToShow
}
// Función para obtener la imagen de usuario. Función aparte de la anterior para que devuelva la imagen guardada o nil
func getUserImage(from user: String) -> Image? {
    var userToShow: Image? = nil
    if let file = getDocumentDirectory()?.appendingPathComponent("\(user).jpg") {
        if FileManager.default.fileExists(atPath: file.path) {
            do {
                let imageData = try Data(contentsOf: file)
                if let savedImage = UIImage(data: imageData) {
                    userToShow = Image(uiImage: savedImage)
                }
            } catch {
                print("Error al convertir la imagen: \(error)")
            }
        }
    }
    return userToShow
}

// Función para borrar una imagen de Archivos en caso de borrar el registro
// De momento solo usada al borrar un ebook: no se pueden borrar books, y al borrar de ReadingList se borraría la imagen del book o ebook correspondiente
func removeJpgFromFileManager(_ file: String) {
	if let fileUrl = getDocumentDirectory()?.appendingPathComponent("\(file).jpg") {
		do {
			try FileManager.default.removeItem(at: fileUrl)
			print("Archivo \(file) borrado con éxito")
		} catch {
			print("Error al borrar el archivo \(file)")
		}
	}
}

// Dejo estas operaciones para macOS a modo de ejemplo de cómo se hace
/*
#if os(macOS)
extension NSImage {
    var jpgData: Data? {
        guard let tiffRepresentation = tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .jpeg, properties: [:])
    }
    
    func jpgWrite(to url: URL, options: Data.WritingOptions = .atomic) {
        do {
            try jpgData?.write(to: url, options: options)
        } catch {
            print(error)
        }
    }
}

func saveJpg(_ image: NSImage, title: String) {
    let name = imageCoverName(from: title)
    if let path = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
        image.jpgWrite(to: path)
        print("Imagen guardada en Archivos")
        print(path.absoluteString)
    } else {
        print("No se pudo guardar la imagen")
    }
}

func loadJpg(title: String) -> NSImage? {
    let name = imageCoverName(from: title)
    if let file = getDocumentDirectory()?.appendingPathComponent("\(name).jpg") {
        if FileManager.default.fileExists(atPath: file.path) {
            do {
                let data = try Data(contentsOf: file)
                let image = NSImage(data: data)
                return image
            } catch {
                print("No se pudo convertir la imagen")
            }
        } else {
            print("No se encontró la imagen en Archivos")
        }
    }
    print("No existe el archivo \(name)")
    return nil
}

// Función para obtener la portada del Bundle o de Archivos

func getCoverImage(from cover: String) -> NSImage {
    var coverToShow = NSImage()
    if let existingCover = NSImage(named: cover) {
        coverToShow = existingCover
    } else {
        if let file = getDocumentDirectory()?.appendingPathComponent("\(cover).jpg") {
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    let coverData = try Data(contentsOf: file)
                    if let savedCover = NSImage(data: coverData) {
                        coverToShow = savedCover
                    }
                } catch {
                    print("Error al convertir la imagen: \(error)")
                }
            }
        }
    }
    return coverToShow
}
#endif
*/

// MARK: - Función para obtener la ruta de los archivos json y exportar

func getURLToShare(from jsonFile: String) -> URL {
    guard var url = Bundle.main.url(forResource: jsonFile, withExtension: nil),
          let documents = getDocumentDirectory() else {
        return URL(string: "")!
    }
    let file = documents.appendingPathComponent(jsonFile)
    if FileManager.default.fileExists(atPath: file.path) {
        url = file
    }
    return url
}
