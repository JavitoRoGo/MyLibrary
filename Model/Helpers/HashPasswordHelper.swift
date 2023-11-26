//
//  HashPasswordHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 26/11/23.
//

import Foundation
import CryptoKit

func hashPassword(_ password: String) -> String? {
	let inputData = Data(password.utf8)
	let hashed = SHA256.hash(data: inputData)
	return hashed.compactMap { String(format: "%02x", $0) }.joined()
}
