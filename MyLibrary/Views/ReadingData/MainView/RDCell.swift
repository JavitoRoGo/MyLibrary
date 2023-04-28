//
//  RDCell.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/22.
//

import SwiftUI

struct RDCell: View {
    let rdata: ReadingData
    var isThereAComment: Bool {
        guard (rdata.comment != nil) else { return false }
        return true
    }
    var isThereALocation: Bool {
        guard (rdata.location != nil) else { return false }
        return true
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: getCoverImage(from: rdata.cover))
                    .resizable()
                    .frame(width: 100, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.white, lineWidth: 4)
                    }
                    .shadow(color: .gray, radius: 7)
                VStack {
                    if isThereAComment {
                        Image(systemName: "quote.bubble")
                            .foregroundColor(.pink)
                    }
                    if isThereALocation {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                .offset(x: 18, y: -8)
            }
            RDStars(rating: .constant(rdata.rating))
        }
        .padding(.vertical)
    }
}

struct RDCell_Previews: PreviewProvider {
    static var previews: some View {
        RDCell(rdata: ReadingData.dataTest)
            .environmentObject(RDModel())
    }
}
