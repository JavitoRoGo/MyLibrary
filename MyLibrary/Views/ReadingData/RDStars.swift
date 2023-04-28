//
//  RDStars.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDStars: View {
    @Binding var rating: Int
    
    var maximumRating = 5
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    var offColor = Color.gray.opacity(0.4)
    var onColor = Color.orange
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}

struct RDStars_Previews: PreviewProvider {
    static var previews: some View {
        RDStars(rating: .constant(3))
            .environmentObject(RDModel())
            .previewLayout(.sizeThatFits)
    }
}
