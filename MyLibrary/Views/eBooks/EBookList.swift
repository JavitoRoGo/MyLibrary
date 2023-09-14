//
//  EBookList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookList: View {
    @EnvironmentObject var model: UserViewModel
	@State var showingGridWithCovers = false
    @State var searchText = ""
    let filter: FilterByStatus
    var filteredOwner: String? = nil
    
    var body: some View {
        NavigationStack {
			if showingGridWithCovers {
				EBookGrid()
			} else {
				List(ebooksToShow) { ebook in
					let index = model.user.ebooks.firstIndex(of: ebook)!
					NavigationLink(destination: EBookDetail(ebook: $model.user.ebooks[index], newStatus: ebook.status)) {
						EBookRow(ebook: ebook)
					}
				}
				.searchable(text: $searchText, prompt: "Búsqueda por título o autor")
				.disableAutocorrection(true)
			}
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button {
					withAnimation {
						showingGridWithCovers.toggle()
					}
				} label: {
					Image(systemName: showingGridWithCovers ? "list.star" : "square.grid.3x3")
				}

			}
		}
    }
}

struct EBookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            EBookList(filter: .all, filteredOwner: nil)
                .environmentObject(UserViewModel())
        }
    }
}
