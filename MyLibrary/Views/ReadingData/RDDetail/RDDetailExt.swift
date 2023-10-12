//
//  RDDetailExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 9/8/23.
//

import SwiftUI

extension RDDetail {
    var isThereAComment: Bool {
        guard (rdata.comment != nil) else { return false }
        return true
    }
    var isThereALocation: Bool {
        guard (rdata.location != nil) else { return false }
        return true
    }
    
    struct RDDetailModifier: ViewModifier {
        @Environment(GlobalViewModel.self) var model
        
        @Binding var rdata: ReadingData
        @Binding var showingLocation: Bool
        @Binding var showingEditView: Bool
        @Binding var showingCommentsAlert: Bool
        
        let isThereALocation: Bool
        
        func body(content: Content) -> some View {
            content
				.navigationTitle("Detalle (\(rdata.id) de \(model.userLogic.user.readingDatas.count))")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                showingLocation = true
                            } label: {
                                Label("Show location", systemImage: "map")
                            }
                            .disabled(!isThereALocation)
                            Button {
                                showingEditView = true
                            } label: {
                                Label("Editar", systemImage: "rectangle.and.pencil.and.ellipsis")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingLocation) {
                    NavigationStack {
                        RDMapView(books: [rdata])
							.toolbar {
								ToolbarItem(placement: .topBarTrailing) {
									Button("Volver") { showingLocation = false }
								}
							}
                    }
                }
                .sheet(isPresented: $showingEditView) {
                    EditRDView(book: $rdata)
                }
                .alert("Comentarios del libro:", isPresented: $showingCommentsAlert) {
                    Button("OK") { }
                } message: {
                    Text(rdata.comment ?? "")
                }
        }
    }
}
