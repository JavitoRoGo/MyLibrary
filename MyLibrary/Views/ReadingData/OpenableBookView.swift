//
//  OpenableBookView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/4/24.
//

import SwiftUI

struct OpenableBookView<Front: View, Left: View, Right: View>: View, Animatable {
	var config: Config = .init()
	@ViewBuilder var front: (CGSize) -> Front
	@ViewBuilder var left: (CGSize) -> Left
	@ViewBuilder var right: (CGSize) -> Right
	
	var animatableData: CGFloat {
		get { config.progress }
		set { config.progress = newValue }
	}
	
    var body: some View {
		GeometryReader {
			let size = $0.size
			let progress = max(min(config.progress, 1), 0)
			let rotation = progress * -180
			
			ZStack {
				right(size)
					.frame(width: size.width, height: size.height)
					.clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
					.shadow(color: .primary.opacity(0.1 * progress), radius: 5, x: 5, y: 0)
					.overlay(alignment: .leading) {
						Rectangle()
							.fill(.secondary.opacity(0.4).shadow(.inner(color: .primary.opacity(0.15), radius: 2)))
							.frame(width: 6)
							.offset(x: -3)
							.clipped()
					}
				
				front(size)
					.frame(width: size.width, height: size.height)
					.allowsHitTesting(-rotation < 90)
					.opacity(-rotation < 90 ? 1 : 0)
					.overlay {
						if -rotation > 90 {
							left(size)
								.frame(width: size.width, height: size.height)
								.scaleEffect(x: -1)
								.transition(.identity)
						}
					}
					.clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 10, topTrailingRadius: 10))
					.shadow(color: .primary.opacity(0.1), radius: 5, x: 5, y: 0)
					.rotation3DEffect(
						.init(degrees: rotation),
						axis: (x: 0.0, y: 1.0, z: 0.0),
						anchor: .leading,
						perspective: 0.3
					)
			}
			.offset(x: (config.width / 2) * progress)
		}
		.frame(width: config.width, height: config.height)
    }
	
	struct Config {
		var width: CGFloat = 150
		var height: CGFloat = 200
		var progress: CGFloat = 0
	}
}

#Preview {
	OpenableBookView() { _ in
		Image(systemName: "book")
	} left: { _ in
		Image(systemName: "star.fill")
	} right: { _ in
		Text("Aquí va el comentario")
	}
}
