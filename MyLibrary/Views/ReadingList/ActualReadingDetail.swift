//
//  ActualReadingDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/3/22.
//

import AVFAudio
import CoreHaptics
import SwiftUI

struct ActualReadingDetail: View {
    @EnvironmentObject var model: NowReadingModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    @EnvironmentObject var rdmodel: RDModel
    
    @State var book: NowReading
    
    @State private var showingEditBook = false
    @State private var showingRatingButtons = false
    @State private var showingFinalAlert = false
    @State private var startEffect = false
    @State private var finishEffect = false
    @State var audioPlayer: AVAudioPlayer!
    @State var engine: CHHapticEngine?
    
    var body: some View {
        ZStack {
            VStack {
                Text(book.bookTitle)
                    .font(.title2)
                HStack(spacing: 20) {
                    VStack {
                        Image(uiImage: getCoverImage(from: imageCoverName(from: book.bookTitle)))
                            .resizable()
                            .frame(width: 120, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .overlay {
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(.white, lineWidth: 4)
                            }
                            .shadow(color: .gray, radius: 7)
                        Text(book.formatt.rawValue)
                            .foregroundColor(.gray)
                    }
                    ProgressRing(book: book)
                }
                
                List {
                    HStack {
                        Text("Siguiente página")
                        Spacer()
                        Text("\(book.nextPage)")
                    }
                    HStack {
                        Text("Tiempo de lectura")
                        Spacer()
                        Text(book.readingTime)
                    }
                    HStack {
                        Text("Tiempo restante")
                        Spacer()
                        Text(!book.isFinished ? minPerDayDoubleToString(book.remainingTime) : "0min")
                    }
                    HStack {
                        Text("Puedes terminar...")
                        Spacer()
                        Text(!book.isFinished ? book.finishingDay.formatted(date: .numeric, time: .omitted) : "-")
                    }
                    
                    Section {
                        NavigationLink(destination: RSList(book: book)) {
                            HStack {
                                Text("Sesiones")
                                Spacer()
                                Text("\(book.sessions.count)")
                            }
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Tiempo / página")
                            Spacer()
                            Text(book.minPerPag)
                        }
                        HStack {
                            Text("Tiempo / sesión")
                            Spacer()
                            Text(book.minPerDay)
                        }
                        HStack {
                            Text("Páginas / sesión")
                            Spacer()
                            Text(book.pagesPerDay, format: .number)
                        }
                    }
                    
                    Section {
                        Text(book.synopsis)
                    }
                }
            }
            EmitterView()
                .scaleEffect(startEffect ? 1 : 0, anchor: .top)
                .opacity(startEffect && !finishEffect ? 1 : 0)
                .offset(y: startEffect ? 0 : getRect().height / 2)
                .ignoresSafeArea()
        }
        .navigationTitle(book.isOnReading ? "Leyendo..." : "En espera...")
        .foregroundColor(book.isOnReading ? .primary : .secondary)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if book.isFinished {
                HStack {
                    Button {
                        playSound()
                        playHaptics()
                        doAnimation()
                    } label: {
                        Label("Repetir", systemImage: "arrow.clockwise")
                    }
                    Button {
                        showingRatingButtons = true
                    } label: {
                        Label("Terminado", systemImage: "checkmark.circle.fill")
                    }
                    .tint(.green)
                }
            } else {
                Button("Editar") {
                    showingEditBook = true
                }
                .disabled(book.isFinished)
            }
        }
        .confirmationDialog("Califica el libro:", isPresented: $showingRatingButtons, titleVisibility: .visible) {
            Button("Cancelar", role: .cancel) { }
            ForEach(1..<6) { rating in
                Button {
                    let newRD = model.createNewRD(from: book, rating: rating)
                    rdmodel.add(newRD)
                    changeToRegistered(book)
                    showingFinalAlert = true
                } label: {
                    Text(rating == 1 ? "1 estrella" : "\(rating) estrellas")
                }
            }
        }
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
        .onAppear {
            prepareHaptics()
            if book.isFinished {
                playSound()
                playHaptics()
                doAnimation()
            }
        }
    }
    
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
}

struct ActualReadingDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActualReadingDetail(book: NowReading.example[0])
                .environmentObject(NowReadingModel())
                .environmentObject(BooksModel())
                .environmentObject(EbooksModel())
                .environmentObject(RDModel())
        }
    }
}
