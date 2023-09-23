//
//  Bundle-Decode.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/22.
//

import Foundation

// Nombre de archivos json
/*
let userJson = "USER.json"




// Extensión de Bundle para cargar los json

extension Bundle {
    
    func searchAndDecode<T: Codable>(_ file: String) -> T? {
        guard var url = self.url(forResource: file, withExtension: nil),
              let documents = getDocumentDirectory() else {
            print("No se encuentra \(file) en el Bundle.")
            return nil
        }
        let fileDocuments = documents.appendingPathComponent(file)
        if FileManager.default.fileExists(atPath: fileDocuments.path) {
            url = fileDocuments
            print("Carga inicial de \(file) desde archivo:\n\(fileDocuments.absoluteString)")
        } else {
            print("Carga inicial de \(file) desde Bundle")
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            print("No se puede cargar \(file) desde el bundle.")
            return nil
        }
        
        guard let loaded = try? JSONDecoder().decode(T.self, from: jsonData) else {
            print("No se decodifica \(file) desde el bundle.")
            return nil
        }
        
        return loaded
    }
}
*/
