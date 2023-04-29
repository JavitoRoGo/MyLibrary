//
//  Functions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/4/22.
//

import Combine
import Foundation
import SwiftUI

// MARK: - Funciones varias

// Funciones para icono y color según estado, y mensajes de información

protocol BooksProtocol {
    var status: ReadingStatus { get set }
}

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

// Funciones para pasar datos de tiempo de tipo String a Double:
// las funciones son iguales, pero las mantengo porque el nombre ayuda a aclarar las unidades del resultado en Double
func minPerPagInMinutes(_ value: String) -> Double {
    var min = 0.0
    var sec = 0.0
    var stringArray = [String]()
    for char in value {
        stringArray.append(String(char))
    }
    let array = stringArray.compactMap { Double($0) }
    if array.count == 1 {
        if stringArray[1] == "m" {
            min = array[0]
        } else {
            sec = array[0]
        }
    } else if array.count == 2 {
        if stringArray[1] == "m" {
            min = array[0]
            sec = array[1]
        } else {
            sec = array[0] * 10 + array[1]
        }
    } else if array.count == 3 {
        min = array[0]
        sec = array[1] * 10 + array[2]
    }
    let total = min + (sec / 60)
    return total
}
func minPerDayInHours(_ value: String) -> Double {
    var hour = 0.0
    var min = 0.0
    var stringArray = [String]()
    for char in value {
        stringArray.append(String(char))
    }
    let array = stringArray.compactMap { Double($0) }
    if array.count == 1 {
        if stringArray[1] == "h" {
            hour = array[0]
        } else {
            min = array[0]
        }
    } else if array.count == 2 {
        if stringArray[1] == "h" {
            hour = array[0]
            min = array[1]
        } else {
            min = array[0] * 10 + array[1]
        }
    } else if array.count == 3 {
        hour = array[0]
        min = array[1] * 10 + array[2]
    }
    let total = hour + (min / 60)
    return total
}

// Funciones para pasar los datos de tiempo de tipo Double a String

func minPerPagDoubleToString(_ value: Double) -> String {
    let float = value.truncatingRemainder(dividingBy: 1)
    let min = Int(value - float)
    let seg = Int(round(float * 60))
    return "\(min)min \(seg)s"
}
func minPerDayDoubleToString(_ value: Double) -> String {
    let float = value.truncatingRemainder(dividingBy: 1)
    let hour = Int(value - float)
    let min = Int(round(float * 60))
    return "\(hour)h \(min)min"
}

// Funciones de comparación de cada valor con la media
func compareWithMean(value: Double, mean: Double) -> (color: Color, image: String) {
    if value >= mean {
        return (Color.green, "arrow.turn.right.up")
    } else {
        return (Color.red, "arrow.turn.right.down")
    }
}

// Función de formato para las fechas de datePicker, devuelve string
func dateToString(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .none
    formatter.dateStyle = .short
    formatter.locale = Locale(identifier: "fr_FR")
    let dateString = formatter.string(from: date)
    return dateString
}
// Función de formato de fechas, devuelve Date desde String
func stringToDate(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yy"
    return formatter.date(from: string) ?? .now
}


// MARK: - Number formatters

let priceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.init(identifier: "fr_FR")
    formatter.numberStyle = .currency
    return formatter
}()

let measureFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.decimalSeparator = ","
    formatter.groupingSeparator = "."
    formatter.minimumFractionDigits = 1
    formatter.maximumFractionDigits = 1
    return formatter
}()

let noDecimalFormatter: NumberFormatter = {
   let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    formatter.groupingSeparator = "."
    return formatter
}()


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

// Función dentro de una clase para obtener la imagen de portada mediante ISBN usando OpenLibrary y Combine
final class BookCoverFromAPI {
    var image: UIImage?
    private var subscribers = Set<AnyCancellable>()
    
    enum SomeError: Error {
        case none
        case general(String)
        case timeout(String)
        case notFound(String)
        case badConnection(String)
    }
    var error: SomeError = .none
    
    private struct Book: Codable {
        let covers: [Int]
    }
    
    init(from isbn: Int) {
        getCover(from: isbn)
    }
    
    private func getCover(from isbn: Int) {
        guard let url = URL(string: "https://openlibrary.org/isbn/\(isbn).json") else { return }
        let bookPublisher = URLSession.shared
            .dataTaskPublisher(for: url)
            .mapError { error -> SomeError in
                if error.errorCode == -1001 {
                    self.error = .timeout(error.localizedDescription)
                    return self.error
                } else {
                    self.error = .general(error.localizedDescription)
                    return self.error
                }
            }
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        return data
                    } else {
                        self.error = SomeError.notFound("Status code \(response.statusCode)")
                        throw self.error
                    }
                } else {
                    self.error = SomeError.badConnection("Conexión errónea")
                    throw self.error
                }
            }
            .decode(type: Book.self, decoder: JSONDecoder())
            .compactMap { $0.covers.first }
            .eraseToAnyPublisher()
        
        func getCoverPublisher(book: Int) -> AnyPublisher<UIImage, Error> {
            let url = URL(string: "https://covers.openlibrary.org/b/id/\(book)-L.jpg")!
            return URLSession.shared
                .dataTaskPublisher(for: url)
                .mapError { error -> SomeError in
                    if error.errorCode == -1001 {
                        self.error = .timeout(error.localizedDescription)
                        return self.error
                    } else {
                        self.error = .general(error.localizedDescription)
                        return self.error
                    }
                }
                .tryMap { data, response in
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            return data
                        } else {
                            self.error = SomeError.notFound("Status code \(response.statusCode)")
                            throw self.error
                        }
                    } else {
                        self.error = SomeError.badConnection("Conexión errónea")
                        throw self.error
                    }
                }
                .compactMap { UIImage(data: $0) }
                .eraseToAnyPublisher()
        }
        
        let coverPublisher = bookPublisher
            .flatMap { book in
                getCoverPublisher(book: book)
            }
        
        Publishers.Zip(bookPublisher, coverPublisher)
            .sink { completion in
                if case .failure = completion {
                    self.image = UIImage(systemName: "questionmark.diamond")!
                }
            } receiveValue: { _, cover in
                self.image = cover
            }
            .store(in: &subscribers)
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


// MARK: - Función para cargar las ubicaciones del usuario, añadiendo dos por defecto

let soldText = "Vendido"
let donatedText = "Donado"

#if os(iOS)
func loadMyPlaces() -> [String] {
    let places: [String] = Bundle.main.searchAndDecode(myPlacesJson) ?? []
    if places.contains(soldText) && places.contains(donatedText) {
        return places
    }
    return places + [donatedText, soldText]
}
#endif
