//
//  EBookList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookList: View {
    @EnvironmentObject var model: GlobalViewModel
    @State var searchText = ""
	@State var customPreferredGridView: Bool
	
    let filter: FilterByStatus
    var filteredOwner: String? = nil
    
    var body: some View {
        NavigationStack {
			if customPreferredGridView {
				EBookGrid(ebooks: ebooksToShow)
			} else {
				List(ebooksToShow) { ebook in
					let index = model.userLogic.user.ebooks.firstIndex(of: ebook)!
					NavigationLink(destination: EBookDetail(ebook: $model.userLogic.user.ebooks[index])) {
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
						customPreferredGridView.toggle()
					}
				} label: {
					Image(systemName: customPreferredGridView ? "list.star" : "square.grid.3x3")
				}

			}
		}
    }
}

struct EBookList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
			EBookList(customPreferredGridView: false, filter: .all, filteredOwner: nil)
				.environmentObject(GlobalViewModel.preview)
        }
    }
}
