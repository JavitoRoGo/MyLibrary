//
//  AllCommentsViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/3/24.
//

import SwiftUI

extension AllCommentsView {
	var comments: [String: String] {
		model.userLogic.allReadingDataComments.merging(model.userLogic.allBookComments) { (first,_) in first }
	}
	
	var searchComments: [String: String] {
		guard !searchText.isEmpty else { return comments }
		return comments.filter {
			$0.key.lowercased().contains(searchText.lowercased())
		}
	}
	
	@ViewBuilder
	func imageAndStars(title: String) -> some View {
		let cover = imageCoverName(from: title)
		if let uiimage = getCoverImage(from: cover) {
			Image(uiImage: uiimage)
				.resizable()
				.modifier(RDCoverModifier(width: 35, height: 50, cornerRadius: 5, lineWidth: 2))
		} else {
			Text(title)
				.modifier(RDCoverModifier(width: 35, height: 50, cornerRadius: 5, lineWidth: 2))
		}
	}
}
