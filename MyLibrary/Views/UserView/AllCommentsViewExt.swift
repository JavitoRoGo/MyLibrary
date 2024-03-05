//
//  AllCommentsViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/3/24.
//

import SwiftUI

extension AllCommentsView {
	var comments: [String: (String, Int)] {
		model.userLogic.allReadingDataComments.merging(model.userLogic.allBookComments) { (first,_) in first }
	}
	
	var searchComments: [String: (String, Int)] {
		guard !searchText.isEmpty else { return comments }
		return comments.filter {
			$0.key.lowercased().contains(searchText.lowercased())
		}
	}
	
	@ViewBuilder
	func imageAndStars(title: String, rating: Int) -> some View {
		let cover = imageCoverName(from: title)
		VStack(spacing: 4) {
			if let uiimage = getCoverImage(from: cover) {
				Image(uiImage: uiimage)
					.resizable()
					.modifier(RDCoverModifier(width: 40, height: 50, cornerRadius: 5, lineWidth: 2))
			} else {
				Text(title)
					.modifier(RDCoverModifier(width: 40, height: 50, cornerRadius: 5, lineWidth: 2))
			}
			
			RDStars(rating: .constant(rating))
				.font(.caption)
		}
	}
}
