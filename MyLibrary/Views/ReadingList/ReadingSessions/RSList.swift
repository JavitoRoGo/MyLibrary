//
//  RSList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 25/2/22.
//

import SwiftUI

struct RSList: View {
    @EnvironmentObject var model: GlobalViewModel
    
    @State var book: NowReading
    @State var showingAddSession = false
    
	var body: some View {
		List {
			Section(book.bookTitle) {
				ForEach(book.sessions) { session in
					if let index = book.sessions.firstIndex(of: session) {
						NavigationLink(destination: RSEdit(book: $book, session: $book.sessions[index])) {
							RSRow(session: session)
								.swipeActions(edge: .trailing) {
									Button(role: .destructive) {
										deleteSessionRow(session)
									} label: {
										Image(systemName: "trash")
									}
									.disabled(!book.isOnReading)
								}
						}
					}
				}
			}
		}
		.modifier(RSListModifier(book: $book, showingAddSession: $showingAddSession))
	}
}

struct RSList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RSList(book: NowReading.dataTest)
				.environmentObject(GlobalViewModel.preview)
        }
    }
}
