//
//  AllCommentsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/1/23.
//

import SwiftUI

struct AllCommentsView: View {
    @Environment(GlobalViewModel.self) var model
    @State private var showingAlert = false
	@State var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if comments.isEmpty {
                    Text("Todavía no has añadido ningún comentario. Puedes añadirlo pulsando \"Editar\" en \"Leyendo\", o pulsando \(Image(systemName: "rectangle.and.pencil.and.ellipsis")) en \"Lecturas\".")
                        .padding(.horizontal)
                } else {
					if !searchComments.isEmpty {
                    	List {
							Section("\(searchComments.count) comentarios") {
								ForEach(Array(searchComments.keys.sorted(by: { $0.lowercased() < $1.lowercased() })), id: \.self) { key in
									let element = searchComments[key, default: ("", 0)]
									HStack(alignment: .top) {
										imageAndStars(title: key, rating: element.1)
										
										VStack(alignment: .leading) {
											Text("\(key):")
												.font(.caption)
												.foregroundColor(.secondary)
											Text(element.0)
												.bold()
										}
									}
									.swipeActions(edge: .trailing) {
										Button {
											showingAlert = true
										} label: {
											Image(systemName: "trash.slash")
										}
										.foregroundColor(.blue)
									}
								}
							}
						}
                    }
					else {
						ContentUnavailableView("No se han encontrado resultados", systemImage: "magnifyingglass")
					}
                }
            }
            .navigationTitle("Comentarios por libro")
            .navigationBarTitleDisplayMode(.inline)
			.autocorrectionDisabled()
			.searchable(text: $searchText, prompt: "Búsqueda por título")
            .alert("No puedes borrar desde aquí.", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text("Para borrar este comentario debes dirigirte al registro correspondiente y eliminarlo ahí.")
            }
        }
    }
}

struct AllCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        AllCommentsView()
			.environment(GlobalViewModel.preview)
    }
}
