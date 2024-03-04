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
    @Environment(GlobalViewModel.self) var model
    
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
						if let uiimage = getCoverImage(from: imageCoverName(from: book.bookTitle)) {
						   Image(uiImage: uiimage)
								.resizable()
								.modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
						} else {
							Text(book.bookTitle)
								.modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
						}
                            
                        Text(book.formatt.rawValue)
                            .foregroundColor(.gray)
                    }
                    ProgressRing(book: book)
                }
                
                dataList
            }
            EmitterView()
                .scaleEffect(startEffect ? 1 : 0, anchor: .top)
                .opacity(startEffect && !finishEffect ? 1 : 0)
                .offset(y: startEffect ? 0 : getRect().height / 2)
                .ignoresSafeArea()
        }
		.modifier(ActualReadingDetailModifier(book: $book, showingEditBook: $showingEditBook, showingFinalAlert: $showingFinalAlert, showingRatingButtons: $showingRatingButtons, playSound: playSound, playHaptics: playHaptics, doAnimation: doAnimation, prepareHaptics: prepareHaptics, changeToRegistered: changeToRegistered))
    }
}

struct ActualReadingDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ActualReadingDetail(book: NowReading.dataTest)
				.environment(GlobalViewModel.preview)
        }
    }
}
