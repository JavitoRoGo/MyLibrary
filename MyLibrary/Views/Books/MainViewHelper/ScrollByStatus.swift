//
//  ScrollByStatus.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct ScrollByStatus: View {
    @EnvironmentObject var model: GlobalViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(ReadingStatus.allCases) { status in
					EachMainViewButton(iconImage: imageNameStatus(status), iconColor: colorStatus(status), number: model.userLogic.numberOfBooksByStatus(status), title: status.rawValue, destination: BookList(customPreferredGridView: model.userLogic.preferredGridView, place: "all", filterByStatus: getFilter(status)))
                }
            }
        }
    }
    
    func getFilter(_ status: ReadingStatus) -> FilterByStatus {
        return FilterByStatus.init(rawValue: status.rawValue) ?? .all
    }
}

struct ScrollByStatus_Previews: PreviewProvider {
    static var previews: some View {
        ScrollByStatus()
			.environmentObject(GlobalViewModel.preview)
    }
}
