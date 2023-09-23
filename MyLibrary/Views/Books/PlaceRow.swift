//
//  PlaceRow.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/12/21.
//

import SwiftUI

struct PlaceRow: View {
    @EnvironmentObject var model: GlobalViewModel
    let place: String
    var number: Int {
		return model.userLogic.numberOfBooksAtPlace(place)
    }
    
    
    var body: some View {
        HStack {
            Text(place == "all" ? "Todos" : place)
                .font(.title2)
            Spacer()
            Text("\(number) \(number != 1 ? "libros" : "libro")")
        }
    }
}

struct PlaceRow_Previews: PreviewProvider {
    static var previews: some View {
        PlaceRow(place: "A1")
			.environmentObject(GlobalViewModel.preview)
            .previewLayout(.fixed(width: 400, height: 50))
    }
}
