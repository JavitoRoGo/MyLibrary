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
    
    let pickerTitles = ["ISBN", "Título", "Autor"]
    @State private var pickerSelection = 0
    @State private var searchText = ""
    
    @State private var showingResults = false
    @State private var showingProgressView = false
    @State private var showingScaledImage = false
    @State private var imageToZoomIn = UIImage()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    Section {
                        Picker("Búsqueda por", selection: $pickerSelection) {
                            ForEach(pickerTitles.indices, id:\.self) { index in
                                Text(pickerTitles[index])
                            }
                        }
                        .pickerStyle(.segmented)
                        TextField("Escribe el ISBN, título o autor a buscar", text: $searchText)
                    }
                    Section {
                        Button {
                            showingProgressView = true
                            resultImages = []
                            showingResults = true
                            Task {
                                resultImages = await downloadCoverFromAPI(searchText: searchText, in: pickerSelection)
                                showingProgressView = false
                            }
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
                                                    withAnimation(.easeIn) {
                                                        imageToZoomIn = uiimage
                                                        showingScaledImage = true
                                                    }
                                                }
                                                .onLongPressGesture {
                                                    selectedImage = uiimage
                                                    dismiss()
                                                }
                                        }
                                    }
                                }
                            }
                        } header: {
                            Text("Toca la imagen para ampliarla y mantenla pulsada para seleccionarla")
                        }
                    }
                }
                
                if showingScaledImage {
                    VStack(spacing: 5) {
                        Text("Toca la imagen para ocultarla")
                            .foregroundColor(.secondary)
                        Image(uiImage: imageToZoomIn)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                showingScaledImage = false
                            }
                        Spacer()
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.ultraThinMaterial)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
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
