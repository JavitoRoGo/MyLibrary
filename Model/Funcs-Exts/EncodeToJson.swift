//
//  EncodeToJson.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 28/5/22.
//

import Foundation

//func saveToJson<T: Codable>(_ myFile: String, _ datas: T) async {
//    guard let documentPath = getDocumentDirectory() else { return }
//    let fileURL = documentPath.appendingPathComponent(myFile)
//    
//    do {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        let data = try encoder.encode(datas)
//        try data.write(to: fileURL, options: .atomic)
//        print("Grabación correcta")
//        print(fileURL.absoluteString)
//    } catch {
//        print("Error en la grabación \(error)")
//    }
//}
