//
//  EBookGrid.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 14/9/23.
//

import SwiftUI

struct EBookGrid: View {
	@EnvironmentObject var model: UserViewModel
	
	let ebooks: [EBooks]
	let columns = [GridItem(.adaptive(minimum: 120))]
	
    var body: some View {
		ScrollView {
			LazyVGrid(columns: columns) {
				ForEach(ebooks) { ebook in
					let index = model.user.ebooks.firstIndex(of: ebook)!
					NavigationLink(destination: EBookDetail(ebook: $model.user.ebooks[index], newStatus: ebook.status)) {
						EBookGridCell(ebook: ebook)
					}
				}
			}
		}
		.padding(.horizontal, 10)
    }
}

struct EBookGrid_Previews: PreviewProvider {
    static var previews: some View {
		EBookGrid(ebooks: [EBooks.dataTest])
			.environmentObject(UserViewModel())
    }
}
