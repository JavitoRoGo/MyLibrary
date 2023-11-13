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
    
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    @State private var showingAddOwner = false
    
    var colors: [Color] {
        getRandomColors()
    }
    
    var body: some View {
		if !model.userLogic.user.myOwners.isEmpty {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 10) {
                    if format == .book {
						ForEach(model.userLogic.user.myOwners, id:\.self) { owner in
							EachMainViewButton(iconImage: "person.circle.fill", iconColor: colors.randomElement()!, number: model.userLogic.numberOfBooksByOwner(owner), title: owner, destination: BookList(customPreferredGridView: preferences.preferredGridView, place: "all", filterByOwner: owner))
                        }
                    } else {
						ForEach(model.userLogic.user.myOwners, id:\.self) { owner in
							EachMainViewButton(iconImage: "person.circle.fill", iconColor: colors.randomElement()!, number: model.userLogic.numberOfEbooksByOwner(owner), title: owner, destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .all, filteredOwner: owner))
                        }
                    }
                }
            }
			.scrollIndicators(.hidden)
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
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
