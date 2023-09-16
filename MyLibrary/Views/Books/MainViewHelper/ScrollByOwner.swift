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
    @State private var showingAddOwner = false
    
    var colors: [Color] {
        getRandomColors()
    }
    
    var body: some View {
		if !model.user.myOwners.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    if format == .book {
						ForEach(model.user.myOwners, id:\.self) { owner in
                            EachMainViewButton(iconImage: "person.circle.fill", iconColor: colors.randomElement()!, number: model.numberOfBooksByOwner(owner), title: owner, destination: BookList(customPreferredGridView: model.preferredGridView, place: "all", filterByOwner: owner))
                        }
                    } else {
						ForEach(model.user.myOwners, id:\.self) { owner in
                            EachMainViewButton(iconImage: "person.circle.fill", iconColor: colors.randomElement()!, number: model.numberOfEbooksByOwner(owner), title: owner, destination: EBookList(customPreferredGridView: model.preferredGridView, filter: .all, filteredOwner: owner))
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
    }
}
