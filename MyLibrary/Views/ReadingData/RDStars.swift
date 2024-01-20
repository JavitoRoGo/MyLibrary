//
//  RDStars.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDStars: View {
    @Binding var rating: Int
    @State private var showBounce = false
    var maximumRating = 5
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<maximumRating, id: \.self) { number in
                Image(systemName: "star")
					.foregroundStyle(number < rating ? .orange : .gray.opacity(0.4))
					.symbolVariant(number < rating ? .fill : .none)
					.symbolEffect(.bounce, value: showBounce)
					.onTapGesture {
						withAnimation(.easeInOut) {
							rating = number + 1
							showBounce.toggle()
						}
                    }
            }
        }
    }
}

struct RDStars_Previews: PreviewProvider {
    static var previews: some View {
        RDStars(rating: .constant(3))
            .previewLayout(.sizeThatFits)
    }
}
