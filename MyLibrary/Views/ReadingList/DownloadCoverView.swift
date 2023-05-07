//
//  DownloadCoverView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/5/23.
//

import SwiftUI

struct DownloadCoverView: View {
    @Environment(\.dismiss) var dismiss
    
    let columns = [GridItem(.adaptive(minimum: 90))]
    @Binding var selectedImage: UIImage?
    @State private var resultImages = [UIImage]()
    
    let pickerTitles = ["ISBN", "Título"]
    @State private var pickerSelection = 0
    @State private var searchText = ""
    
    @State private var showingResults = false
    @State private var showingProgressView = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Búsqueda por", selection: $pickerSelection) {
                        ForEach(pickerTitles.indices, id:\.self) { index in
                            Text(pickerTitles[index])
                        }
                    }
                    .pickerStyle(.segmented)
                    TextField("Escribe aquí el título, autor o ISBN", text: $searchText)
                }
                Section {
                    Button {
                        resultImages = []
//                        showingProgressView = true
                        showingResults = true
                        Task {
                            resultImages = await downloadCoverFromAPI(selection: pickerSelection, searchText: searchText)
                        }
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
//                            showingProgressView = false
//                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text("Buscar")
                            Spacer()
                        }
                    }
                }
                if showingResults {
                    Section {
                        if showingProgressView {
                            ProgressView()
                        } else {
                            ScrollView {
                                LazyVGrid(columns: columns) {
                                    ForEach(resultImages, id: \.self) { uiimage in
                                        Image(uiImage: uiimage)
                                            .resizable()
                                            .frame(width: 90, height: 120)
                                            .onTapGesture {
                                                selectedImage = uiimage
                                                dismiss()
                                            }
                                    }
                                }
                            }
                        }
                    } header: {
                        Text("Pulsa sobre la portada para seleccionarla")
                    }
                }
            }
            .navigationTitle("Descarga la portada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
            }
        }
    }
}

struct DownloadCoverView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DownloadCoverView(selectedImage: .constant(UIImage(named: "cover001")))
        }
    }
}
