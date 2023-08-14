//
//  RDRow.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDRow: View {
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
        HStack {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: getCoverImage(from: rdata.cover))
                    .resizable()
                    .modifier(RDCoverModifier(width: 60, height: 80, cornerRadius: 10, lineWidth: 4))
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
            VStack(alignment: .leading) {
                Text(rdata.bookTitle)
                    .font(.title2)
                RDStars(rating: .constant(rdata.rating))
            }
            .padding(.leading, 15)
            Spacer()
        }
        .fixedSize()
    }
}

struct RDRow_Previews: PreviewProvider {
    static var previews: some View {
        RDRow(rdata: ReadingData.dataTest)
            .environmentObject(RDModel())
            .previewLayout(.fixed(width: 400, height: 150))
    }
}
