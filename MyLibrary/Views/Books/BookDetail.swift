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
            authorSection
            
            publisherSection
            
            physicalCharsSection
            
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
            .environmentObject(UserViewModel())
    }
}
