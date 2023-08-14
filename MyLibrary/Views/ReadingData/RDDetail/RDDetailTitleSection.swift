//
//  RDDetailTitleSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension RDDetail {
	var titleSection: some View {
		Section("Nº \(rdata.yearId) del año \(String(rdata.finishedInYear.rawValue))") {
			HStack {
				VStack(alignment: .leading) {
					Text("Título:")
						.font(.subheadline)
					Text(rdata.bookTitle)
						.font(.headline)
				}
				Spacer()
				if isThereAComment {
					Button {
						showingCommentsAlert = true
					} label: {
						Image(systemName: "quote.bubble")
							.font(.title3)
							.foregroundColor(.pink)
					}
				}
			}
		}
	}
}
