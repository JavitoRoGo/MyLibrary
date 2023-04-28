//
//  EBookDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookDetail: View {
    @EnvironmentObject var emodel: EbooksModel
    @EnvironmentObject var rdmodel: RDModel
    @EnvironmentObject var nrmodel: NowReadingModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var ebook: EBooks
    @State var newStatus: ReadingStatus
    
    @State private var showingEditPage = false
    @State private var showingInfoAlert = false
    @State private var titleInfoAlert = ""
    @State private var messageInfoAlert = ""
    
    @State private var showingDeleteAlert = false
    @State private var showingRDDetail = false
    @State private var showingRSDetail = false
    @State private var showingAddWaitingList = false
    @State private var isOnWaitingList = false
    
    var body: some View {
        VStack {
            List {
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Autor:")
                                .font(.subheadline)
                            Text(ebook.author)
                                .font(.headline)
                        }
                        Spacer()
                        Button {
                            titleInfoAlert = setInfoAlertFor(ebook).title
                            messageInfoAlert = setInfoAlertFor(ebook).message
                            showingInfoAlert = true
                        } label: {
                            imageStatus(ebook)
                                .font(.title)
                                .foregroundColor(colorStatus(ebook.status))
                        }
                        .buttonStyle(.bordered)
                    }
                    VStack(alignment: .leading) {
                        Text("Título:")
                            .font(.subheadline)
                        Text(ebook.bookTitle)
                            .font(.headline)
                    }
                    VStack(alignment: .leading) {
                        Text("Título original:")
                            .font(.subheadline)
                        Text(ebook.originalTitle)
                            .font(.headline)
                    }
                }
                
                Section {
                    HStack {
                        VStack {
                            Text("Año:")
                                .font(.subheadline)
                            Text(String(ebook.year))
                                .font(.headline)
                        }
                        Spacer()
                        VStack {
                            Text("Páginas:")
                                .font(.subheadline)
                            Text(String(ebook.pages))
                                .font(.headline)
                        }
                        Spacer()
                        VStack {
                            Text("Precio:")
                                .font(.subheadline)
                            Text(priceFormatter.string(from: NSNumber(value: ebook.price))!)
                                .font(.headline)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Propietario:")
                            .font(.subheadline)
                        Spacer()
                        Text(ebook.owner)
                            .font(.headline)
                    }
                }
                
                Section {
                    if let text = ebook.synopsis {
                        Text(text)
                    } else {
                        Text("Sinopsis no disponible.")
                    }
                }
            }
            .navigationTitle("Detalle (\(ebook.id) de \(emodel.ebooks.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                HStack {
                    Button {
                        showingDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                    Button {
                        showingEditPage = true
                    } label: {
                        Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    }
                    .disabled(showingEditPage)
                }
            }
            .alert(titleInfoAlert, isPresented: $showingInfoAlert) {
                if ebook.status == .registered {
                    Button("Cancelar", role: .cancel) { }
                    Button("Ver") {
                        showingRDDetail = true
                    }
                } else if ebook.status == .reading {
                    Button("Cancelar", role: .cancel) { }
                    Button("Ver") {
                        showingRSDetail = true
                    }
                } else {
                    Button("Aceptar", role: .cancel) { }
                }
            } message: {
                Text(messageInfoAlert)
            }
            .sheet(isPresented: $showingRDDetail) {
                if let rdata = rdmodel.readingDatas.first(where: { $0.bookTitle == ebook.bookTitle }) {
                    NavigationView {
                        RDDetail(rdata: rdata)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancelar") {
                                        showingRDDetail = false
                                    }
                                }
                            }
                    }
                }
            }
            .sheet(isPresented: $showingRSDetail) {
                if let rsdata = nrmodel.readingList.first(where: { $0.bookTitle == ebook.bookTitle }) {
                    NavigationView {
                        ActualReadingDetail(book: rsdata)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button("Cancelar") {
                                        showingRSDetail = false
                                    }
                                }
                            }
                    }
                }
            }
            .alert("¿Deseas eliminar este registro?", isPresented: $showingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    if let index = emodel.ebooks.firstIndex(of: ebook) {
                        emodel.ebooks.remove(at: index)
                        dismiss()
                    }
                }
            } message: {
                Text("Esta acción no podrá deshacerse.")
            }
            
            if showingEditPage {
                VStack {
                    HStack {
                        Button("Cancelar") {
                            showingEditPage = false
                        }
                        Spacer()
                        Text("¿Editar?")
                        Spacer()
                        Button("Modificar") {
                            ebook.status = newStatus
                            showingEditPage = false
                        }
                    }
                    .padding(.horizontal)
                    Picker("Estado", selection: $newStatus) {
                        ForEach(ReadingStatus.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.wheel)
                    if newStatus == .notRead || newStatus == .reading || newStatus == .waiting {
                        VStack {
                            HStack {
                                Text("¿Está en la lista de lectura?")
                                Spacer()
                                Image(systemName: isOnWaitingList ? "star.fill" : "star")
                                    .foregroundColor(isOnWaitingList ? .yellow : .gray.opacity(0.8))
                            }
                            Toggle("Añadir a la lista de lectura", isOn: $showingAddWaitingList)
                                .foregroundColor(isOnWaitingList ? .secondary : .primary)
                                .disabled(isOnWaitingList)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddWaitingList) {
            NavigationView {
                AddReading(bookTitle: ebook.bookTitle, synopsis: ebook.synopsis ?? "Sinopsis no disponible.", formatt: .kindle)
            }
        }
        .onAppear {
            isOnWaitingList = nrmodel.readingList.contains(where: { $0.bookTitle == ebook.bookTitle }) ||
            nrmodel.waitingList.contains(where: { $0.bookTitle == ebook.bookTitle })
        }
    }
}

struct EBookDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EBookDetail(ebook: .constant(EBooks.dataTest), newStatus: .consulting)
                .environmentObject(EbooksModel())
                .environmentObject(RDModel())
                .environmentObject(NowReadingModel())
        }
    }
}
