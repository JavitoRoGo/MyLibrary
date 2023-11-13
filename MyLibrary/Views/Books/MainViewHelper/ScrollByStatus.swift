//
//  ScrollByStatus.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct ScrollByStatus: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(ReadingStatus.allCases) { status in
					EachMainViewButton(iconImage: status.iconName, iconColor: status.iconColor, number: model.userLogic.numberOfBooksByStatus(status), title: status.rawValue, destination: BookList(customPreferredGridView: preferences.preferredGridView, place: "all", filterByStatus: getFilter(status)))
                }
            }
        }
		.scrollIndicators(.hidden)
    }
    
    func getFilter(_ status: ReadingStatus) -> FilterByStatus {
        return FilterByStatus.init(rawValue: status.rawValue) ?? .all
    }
}

struct ScrollByStatus_Previews: PreviewProvider {
    static var previews: some View {
        ScrollByStatus()
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
