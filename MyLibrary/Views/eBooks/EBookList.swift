//
//  EBookList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookList: View {
    @EnvironmentObject var model: UserViewModel
    @State var searchText = ""
	@State private var customPreferredGridVew = false
	
    let filter: FilterByStatus
    var filteredOwner: String? = nil
    
    var body: some View {
        NavigationStack {
			if customPreferredGridVew {
				EBookGrid(ebooks: ebooksToShow)
			} else {
				List(ebooksToShow) { ebook in
					let index = model.user.ebooks.firstIndex(of: ebook)!
					NavigationLink(destination: EBookDetail(ebook: $model.user.ebooks[index])) {
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
						customPreferredGridVew.toggle()
					}
				} label: {
					Image(systemName: customPreferredGridVew ? "list.star" : "square.grid.3x3")
				}

			}
		}
		.onAppear { customPreferredGridVew = model.preferredGridView }
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
