//
//  EBookDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookDetail: View {
    @EnvironmentObject var nrmodel: NowReadingModel
    
    @Binding var ebook: EBooks
    @State var newStatus: ReadingStatus
    
    @State var showingEditPage = false
    @State var showingInfoAlert = false
    @State var titleInfoAlert = ""
    @State var messageInfoAlert = ""
    
    @State var showingDeleteAlert = false
    @State var showingRDDetail = false
    @State var showingRSDetail = false
    @State var showingAddWaitingList = false
    @State var isOnWaitingList = false
    
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
            .modifier(EBookDetailModifier(showingDeleteAlert: $showingDeleteAlert, showingEditPage: $showingEditPage, showingInfoAlert: $showingInfoAlert, showingRDDetail: $showingRDDetail, showingRSDetail: $showingRDDetail, ebook: ebook, titleInfoAlert: titleInfoAlert, messageInfoAlert: messageInfoAlert))
            
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
