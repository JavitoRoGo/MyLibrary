//
//  ConnectivityManager.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/2/23.
//

import Foundation
import WatchConnectivity

final class ConnectivityMaganer: NSObject, ObservableObject {
    var session: WCSession
    @Published var booksOnReading: [NowReading] = []
    @Published var booksOnWaiting: [NowReading] = []
    @Published var readingTime = 0
    
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        if WCSession.isSupported() {
            self.session.delegate = self
            self.session.activate()
        }
    }
}

extension ConnectivityMaganer: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error {
            print(error.localizedDescription)
        } else {
            print("The WCSession has completed activation.")
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    
    // Función para recibir el tiempo de lectura
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let time = message["timeRead"] as? Int {
            readingTime = time
        }
    }
    #endif
    
    #if os(watchOS)
    // Función para recibir lista de lectura y espera
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async {
            if let book = try? JSONDecoder().decode(NowReading.self, from: messageData) {
                if book.isOnReading {
                    self.booksOnReading.append(book)
                } else {
                    self.booksOnWaiting.append(book)
                }
            }
        }
    }
    #endif
}
