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
    let filter: FilterByStatus
    var filteredOwner: String? = nil
    
    var body: some View {
        List(ebooksToShow) { ebook in
			let index = model.user.ebooks.firstIndex(of: ebook)!
			NavigationLink(destination: EBookDetail(ebook: $model.user.ebooks[index], newStatus: ebook.status)) {
                EBookRow(ebook: ebook)
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Búsqueda por título o autor")
        .disableAutocorrection(true)
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
