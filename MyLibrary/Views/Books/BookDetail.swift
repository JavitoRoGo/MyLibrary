//
//  BookDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct BookDetail: View {
    @State var book: Books
    
    @State var showingEditPage = false
    @State var showingInfoAlert = false
    @State var titleInfoAlert = ""
    @State var messageInfoAlert = ""
    
    @State var showingDelete = false
    @State var showingRDDetail = false
    @State var showingRSDetail = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Autor:")
                            .font(.subheadline)
                        Text(book.author)
                            .font(.headline)
                    }
                    Spacer()
                    Button {
                        titleInfoAlert = setInfoAlertFor(book).title
                        messageInfoAlert = setInfoAlertFor(book).message
                        showingInfoAlert = true
                    } label: {
                        imageStatus(book)
                            .font(.title)
                            .foregroundColor(colorStatus(book.status))
                    }
                    .buttonStyle(.bordered)
                }
                VStack(alignment: .leading) {
                    Text("Título:")
                        .font(.subheadline)
                    Text(book.bookTitle)
                        .font(.headline)
                }
                VStack(alignment: .leading) {
                    Text("Título original:")
                        .font(.subheadline)
                    Text(book.originalTitle)
                        .font(.headline)
                }
            }
            
            Section {
                VStack(alignment: .leading) {
                    Text("Editorial:")
                        .font(.subheadline)
                    Text(book.publisher)
                        .font(.headline)
                }
                VStack(alignment: .leading) {
                    Text("Ciudad:")
                        .font(.subheadline)
                    Text(book.city)
                        .font(.headline)
                }
                HStack {
                    VStack {
                        Text("Edición:")
                            .font(.subheadline)
                        Text(book.edition, format: .number)
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Año:")
                            .font(.subheadline)
                        Text(String(book.editionYear))
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Año escritura:")
                            .font(.subheadline)
                        Text(String(book.writingYear))
                            .font(.headline)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Encuadernación:")
                            .font(.subheadline)
                        Text(book.coverType.rawValue)
                            .font(.headline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("ISBN:")
                            .font(.subheadline)
                        Text("\(book.isbn1)-\(book.isbn2)-\(book.isbn3)-\(book.isbn4)-\(book.isbn5)")
                            .font(.headline)
                    }
                }
            }
            
            Section {
                HStack {
                    VStack {
                        Text("Páginas:")
                            .font(.subheadline)
                        Text(String(book.pages))
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Precio:")
                            .font(.subheadline)
                        Text(priceFormatter.string(from: NSNumber(value: book.price))!)
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Peso (g):")
                            .font(.subheadline)
                        Text(String(book.weight))
                            .font(.headline)
                    }
                }
                HStack {
                    VStack {
                        Text("Alto (cm):")
                            .font(.subheadline)
                        Text(measureFormatter.string(from: NSNumber(value: book.height))!)
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Ancho (cm):")
                            .font(.subheadline)
                        Text(measureFormatter.string(from: NSNumber(value: book.width))!)
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Grosor (cm):")
                            .font(.subheadline)
                        Text(measureFormatter.string(from: NSNumber(value: book.thickness))!)
                            .font(.headline)
                    }
                }
            }
            
            Section {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Propietario:")
                            .font(.subheadline)
                        Text(book.owner)
                            .font(.headline)
                    }
                    Spacer()
                    VStack {
                        Text("Ubicación:")
                            .font(.subheadline)
                        Text(book.place)
                            .font(.headline)
                    }
                }
            }
            
            Section {
                if let text = book.synopsis, !text.isEmpty {
                    Text(text)
                } else {
                    Text("Sinopsis no disponible.")
                }
            }
        }
        .modifier(BookDetailModifier(book: book, showingDelete: $showingDelete, showingEditPage: $showingEditPage, showingInfoAlert: $showingInfoAlert, showingRDDetail: $showingRDDetail, showingRSDetail: $showingRDDetail, titleInfoAlert: titleInfoAlert, messageInfoAlert: messageInfoAlert))
    }
}

struct BookDetail_Previews: PreviewProvider {
    static var previews: some View {
        BookDetail(book: Books.dataTest)
            .environmentObject(BooksModel())
            .environmentObject(RDModel())
            .environmentObject(NowReadingModel())
    }
}
