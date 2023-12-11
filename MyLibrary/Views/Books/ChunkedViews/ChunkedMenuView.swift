//
//  ChunkedMenuView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/12/23.
//

import SwiftUI

struct ChunkedMenuView: View {
    var body: some View {
		List {
			NavigationLink(destination: PlaceList()) {
				HStack {
					Image(systemName: "books.vertical")
						.foregroundColor(.pink)
					Text("Ubicación")
				}
			}
			
			Section {
				NavigationLink(destination: ChunkedByAuthorView()) {
					HStack {
						Image(systemName: "person.3")
							.foregroundColor(.blue)
						Text("Autor")
					}
				}
				NavigationLink(destination: ChunkedByPublisherView()) {
					HStack {
						Image(systemName: "building.columns")
							.foregroundColor(.blue)
						Text("Editorial")
					}
				}
			}
			
			Section {
				NavigationLink(destination: ChunkedByEditionView()) {
					HStack {
						Image(systemName: "number")
							.foregroundColor(.orange)
						Text("Edición")
					}
				}
				NavigationLink(destination: ChunkedByEditionYearView()) {
					HStack {
						Image(systemName: "calendar")
							.foregroundColor(.green)
						Text("Año de edición")
					}
				}
				NavigationLink(destination: ChunkedByWritingYear()) {
					HStack {
						Image(systemName: "calendar.badge.clock")
							.foregroundColor(.purple)
						Text("Año de escritura")
					}
				}
			}
			
			Section {
				NavigationLink(destination: ChunkedByPagesView()) {
					HStack {
						Image(systemName: "123.rectangle.fill")
						Text("Páginas")
					}
				}
			}
		}
		.navigationTitle("Filtros por...")
		.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ChunkedMenuView()
}
