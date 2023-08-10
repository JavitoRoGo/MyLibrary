//
//  ActualReadingDetailExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/8/23.
//

import AVFAudio
import CoreHaptics
import SwiftUI

extension ActualReadingDetail {
	func doAnimation() {
		withAnimation(.spring()) {
			startEffect = true
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			withAnimation(.easeInOut(duration: 1.5)) {
				finishEffect = true
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				finishEffect = false
				startEffect = false
			}
		}
	}
	
	func playSound() {
		guard let url = Bundle.main.url(forResource: "explosion.caf", withExtension: nil) else {
			fatalError("No se encuentra el archivo de sonido.")
		}
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
		} catch {
			print(error.localizedDescription)
		}
		audioPlayer.play()
	}
	
	func prepareHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		do {
			engine = try CHHapticEngine()
			try engine?.start()
		} catch {
			print("Error creating engine: \(error.localizedDescription)")
		}
	}
	
	func playHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		var events = [CHHapticEvent]()
		
		for i in stride(from: 0, to: 1, by: 0.1) {
			let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
			let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
			let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
			events.append(event)
		}
		
		for i in stride(from: 0, to: 1, by: 0.1) {
			let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
			let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
			let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
			events.append(event)
		}
		
		do {
			let pattern = try CHHapticPattern(events: events, parameters: [])
			let player = try engine?.makePlayer(with: pattern)
			try player?.start(atTime: 0)
		} catch {
			print("Failed to play pattern: \(error.localizedDescription)")
		}
	}
	
	func changeToRegistered(_ book: NowReading) {
		if book.formatt == .paper {
			if let index = BooksModel().books.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				bmodel.books[index].status = .registered
			}
		} else {
			if let index = EbooksModel().ebooks.firstIndex(where: { $0.bookTitle == book.bookTitle }) {
				emodel.ebooks[index].status = .registered
			}
		}
	}
	
	struct ActualReadingDetailModifier: ViewModifier {
		@EnvironmentObject var model: NowReadingModel
		
		@Binding var book: NowReading
		@Binding var showingEditBook: Bool
		@Binding var showingFinalAlert: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle(book.isOnReading ? "Leyendo..." : "En espera...")
				.foregroundColor(book.isOnReading ? .primary : .secondary)
				.navigationBarTitleDisplayMode(.inline)
				.alert("Registro añadido.", isPresented: $showingFinalAlert) {
					Button("Aceptar") {
						model.removeFromReading(book)
					}
				} message: {
					Text("Se ha cambiado el estado del libro a \"Registrado\".")
				}
				.sheet(isPresented: $showingEditBook) {
					NavigationView {
						ActualReadingEdit(book: $book)
					}
				}
		}
	}
}
