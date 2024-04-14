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
	
	@Binding var openningProgress: CGFloat
	
	var uiimage: UIImage {
		if let image = getCoverImage(from: rdata.cover) {
			image
		} else {
			UIImage(systemName: "questionmark")!
		}
	}
    
    var body: some View {
        VStack {
			if let comment = rdata.comment {
				Group {
					OpenableBookView(config: .init(width: 130, height: 180, progress: openningProgress)) { size in
						Image(uiImage: uiimage)
							.resizable()
					} left: { size in
						VStack(spacing: 5) {
							Text(rdata.bookTitle)
								.fontWidth(.condensed)
							RDStars(rating: .constant(rdata.rating))
						}
						.padding(.horizontal, 3)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(.teal.opacity(0.2))
					} right: { size in
						VStack(alignment: .leading, spacing: 8) {
							Text("Comentario:")
								.fontWeight(.semibold)
								.font(.system(size: 14))
							Text(comment)
								.font(.caption)
								.foregroundStyle(.secondary)
							Spacer()
						}
						.padding(.top, 8)
						.padding(.horizontal, 4)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(.teal.opacity(0.2))
					}
				}
			} else {
				Image(uiImage: uiimage)
					.resizable()
					.modifier(RDCoverModifier(width: 130, height: 180, cornerRadius: 30, lineWidth: 4))
					.rotation3DEffect(.degrees(spinAmount), axis: (x: 0, y: 1, z: 0))
			}
            
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
		RDScroll(rdata: .constant(ReadingData.example[0]), openningProgress: .constant(0))
			.environment(GlobalViewModel.preview)
//            .previewLayout(.fixed(width: 400, height: 250))
    }
}
