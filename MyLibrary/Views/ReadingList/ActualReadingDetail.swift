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
    @EnvironmentObject var rdmodel: RDModel
    
    @State var book: NowReading
    
    @State var showingEditBook = false
    @State var showingRatingButtons = false
    @State var showingFinalAlert = false
    @State var startEffect = false
    @State var finishEffect = false
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
		.modifier(ActualReadingDetailModifier(book: $book, showingEditBook: $showingEditBook, showingFinalAlert: $showingFinalAlert))
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
		.onAppear {
			prepareHaptics()
			if book.isFinished {
				playSound()
				playHaptics()
				doAnimation()
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
