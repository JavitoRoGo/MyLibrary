//
//  RDDetailDataSection.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension RDDetail {
	var dataSection: some View {
		Section {
			VStack(alignment: .leading) {
				Text("Inicio - Fin:")
					.font(.subheadline)
				Text("\(rdata.startDate.toString) - \(rdata.finishDate.toString)")
					.font(.headline)
			}
			NavigationLink(destination: RDSessions(rdsessions: rdata.readingSessions, rdata: rdata)) {
				HStack {
					Text("Sesiones:")
						.font(.subheadline)
					Spacer()
					Text(String(rdata.sessions))
						.font(.headline)
				}
			}
			HStack {
				VStack(alignment: .leading) {
					Text("Tiempo:")
						.font(.subheadline)
					Text(rdata.duration)
						.font(.headline)
				}
				Spacer()
				VStack {
					Text("Páginas:")
						.font(.subheadline)
					Text(String(rdata.pages))
						.font(.headline)
				}
				Spacer()
				VStack {
					Text(">\(preferences.dailyPagesTarget) pág:")
						.font(.subheadline)
					Text(String(rdata.over50))
						.font(.headline)
				}
			}
		}
	}
}
