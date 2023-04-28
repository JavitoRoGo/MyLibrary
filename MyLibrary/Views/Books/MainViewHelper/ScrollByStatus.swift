//
//  ScrollByStatus.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct ScrollByStatus: View {
    @EnvironmentObject var model: BooksModel
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(ReadingStatus.allCases) { status in
                    EachMainViewButton(iconImage: imageNameStatus(status), iconColor: colorStatus(status), number: model.books.filter{$0.status == status && $0.isActive}.count, title: status.rawValue, destination: BookList(place: "all", filterByStatus: getFilter(status)))
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
            .environmentObject(BooksModel())
    }
}
