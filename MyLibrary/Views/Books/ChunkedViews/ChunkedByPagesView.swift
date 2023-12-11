//
//  ChunkedByPagesView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/23.
//

import Algorithms
import SwiftUI

struct ChunkedByPagesView: View {
	@Environment(GlobalViewModel.self) var model
	
	let ranges = [[1, 100], [101, 200], [201, 300], [301, 400], [401, 500], [501, 600], [601, 700], [701, 800], [801, 900], [901, 1000]]
	
	var booksChunkedByPages: [[Books]] {
		let sorted = model.userLogic.activeBooks.sorted { $0.pages < $1.pages }
		var books = [[Books]]()
		
		return books
	}
	
    var body: some View {
		List {
			
		}
    }
}

#Preview {
    ChunkedByPagesView()
		.environment(GlobalViewModel.preview)
}
