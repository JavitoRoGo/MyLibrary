//
//  RDDetailTitleSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension RDDetail {
	var titleSection: some View {
		Section("Nº \(rdata.yearId) del año \(String(rdata.finishedInYear))") {
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
						withAnimation(.snappy(duration: 1)) {
							openingProgress = (openingProgress == 1 ? 0 : 1)
						}
					} label: {
						Image(systemName: "quote.bubble")
							.font(.title3)
							.foregroundColor(.pink)
					}
					.buttonStyle(.bordered)
				}
			}
		}
	}
}
