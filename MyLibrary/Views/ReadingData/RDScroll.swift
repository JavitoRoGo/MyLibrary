//
//  RDScroll.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/1/22.
//

import SwiftUI

struct RDScroll: View {
    @Environment(GlobalViewModel.self) var model
    @Binding var rdata: ReadingData
    @State private var spinAmount = 0.0
    @State private var buttonTapped = 0
    
	@State var scrollIndex: ReadingData.ID?
	
	var uiimage: UIImage {
		if let image = getCoverImage(from: rdata.cover) {
			image
		} else {
			UIImage(systemName: "questionmark")!
		}
	}
    
    var body: some View {
        VStack {
            Image(uiImage: uiimage)
                .resizable()
                .modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
                .rotation3DEffect(.degrees(spinAmount), axis: (x: 0, y: 1, z: 0))
            
			ScrollView(.horizontal) {
				LazyHStack {
					ForEach(model.userLogic.user.readingDatas.reversed()) { rdata in
						let index = model.userLogic.user.readingDatas.firstIndex(of: rdata)!
						Button {
							buttonTapped = 0
							withAnimation {
								self.rdata = rdata
								buttonTapped = index
								spinAmount += 360
							}
						} label: {
							let uiimage = getCoverImage(from: rdata.cover) ?? UIImage(systemName: "questionmark")!
							Image(uiImage: uiimage)
								.resizable()
								.frame(width: 50, height: 50)
								.clipShape(Circle())
								.overlay {
									Circle().stroke(.white, lineWidth: 1)
								}
								.shadow(color: .gray, radius: 7)
						}
						.rotation3DEffect(buttonTapped == index ? .degrees(spinAmount) : .degrees(0), axis: (x: 0, y: 1, z: 0))
					}
				}
				.frame(height: 75)
			}
			.scrollIndicators(.hidden)
			.scrollPosition(id: $scrollIndex)
			.onAppear {
				scrollIndex = rdata.id
			}
        }
    }
}

struct RDScroll_Previews: PreviewProvider {
    static var previews: some View {
		RDScroll(rdata: .constant(ReadingData.dataTest))
			.environment(GlobalViewModel.preview)
            .previewLayout(.fixed(width: 400, height: 250))
    }
}
