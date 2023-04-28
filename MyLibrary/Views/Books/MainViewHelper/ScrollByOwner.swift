//
//  ScrollByOwner.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct ScrollByOwner: View {
    enum BookFormat {
        case book, ebook
    }
    let format: BookFormat
    
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @EnvironmentObject var emodel: EbooksModel
    @State private var showingAddOwner = false
    
    var colors: [Color] {
        getRandomColors()
    }
    
    var body: some View {
        if !model.myOwners.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    if format == .book {
                        ForEach(model.myOwners, id:\.self) { owner in
                            EachMainViewButton(iconImage: "person.circle.fill", iconColor: colors.randomElement()!, number: bmodel.numByOwner(owner), title: owner, destination: BookList(place: "all", filterByOwner: owner))
                        }
                    } else {
                        ForEach(model.myOwners, id:\.self) { owner in
                            EachMainViewButton(iconImage: "person.circle.fill", iconColor: colors.randomElement()!, number: emodel.numByOwner(owner), title: owner, destination: EBookList(filter: .all, filteredOwner: owner))
                        }
                    }
                }
            }
        } else {
            VStack {
                Text("No existe ningún propietario. Pulsa para crear uno nuevo.")
                Button("Crear propietario") {
                    showingAddOwner.toggle()
                }
                .foregroundColor(.blue)
                .buttonStyle(.bordered)
            }
            .padding()
            .background(ButtonBackground())
            .sheet(isPresented: $showingAddOwner) {
                NavigationStack {
                    EditOwners()
                }
            }
        }
    }
}

struct ScrollByOwner_Previews: PreviewProvider {
    static var previews: some View {
        ScrollByOwner(format: .ebook)
            .environmentObject(UserViewModel())
            .environmentObject(BooksModel())
            .environmentObject(EbooksModel())
    }
}
