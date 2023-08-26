//
//  AllCommentsView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/1/23.
//

import SwiftUI

struct AllCommentsView: View {
    @EnvironmentObject var rdmodel: RDModel
    @EnvironmentObject var model: UserViewModel
    @State private var showingAlert = false
    
    var comments: [String: String] {
        rdmodel.allBookComments.merging(model.allBookComments) { (first,_) in first }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if comments.isEmpty {
                    Text("Todavía no has añadido ningún comentario. Puedes añadirlo pulsando \"Editar\" en \"Leyendo\", o pulsando \(Image(systemName: "rectangle.and.pencil.and.ellipsis")) en \"Registros\".")
                        .padding(.horizontal)
                } else {
                    List {
                        Section("\(comments.count) comentarios") {
                            ForEach(Array(comments.keys), id: \.self) { key in
                                VStack(alignment: .leading) {
                                    Text("\(key):")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(comments[key]!)
                                        .bold()
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
            }
            .navigationTitle("Comentarios por libro")
            .navigationBarTitleDisplayMode(.inline)
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
            .environmentObject(RDModel())
            .environmentObject(UserViewModel())
    }
}
