//
//  RDScroll.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 4/1/22.
//

import SwiftUI

struct RDScroll: View {
    @EnvironmentObject var model: RDModel
    @Binding var rdata: ReadingData
    @State private var spinAmount = 0.0
    @State private var buttonTapped = 0
    
    var index: Int {
        model.readingDatas.firstIndex(of: rdata) ?? 0
    }
    
    var body: some View {
        VStack {
            Image(uiImage: getCoverImage(from: rdata.cover))
                .resizable()
                .frame(width: 120, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.white, lineWidth: 4)
                }
                .shadow(color: .gray, radius: 7)
                .rotation3DEffect(.degrees(spinAmount), axis: (x: 0, y: 1, z: 0))
            
            ScrollViewReader { value in
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(model.readingDatas.reversed()) { rdata in
                            let index = model.readingDatas.firstIndex(of: rdata)!
                            Button {
                                buttonTapped = 0
                                withAnimation {
                                    self.rdata = rdata
                                    buttonTapped = index
                                    spinAmount += 360
                                }
                            } label: {
                                Image(uiImage: getCoverImage(from: rdata.cover))
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay {
                                        Circle().stroke(.white, lineWidth: 1)
                                    }
                                    .shadow(color: .gray, radius: 7)
                            }
                            .rotation3DEffect(buttonTapped == index ? .degrees(spinAmount) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }
                .task {
                    value.scrollTo(index, anchor: .center)
                }
            }
        }
    }
}

struct RDScroll_Previews: PreviewProvider {
    static var previews: some View {
        RDScroll(rdata: .constant(ReadingData.dataTest))
            .environmentObject(RDModel())
            .previewLayout(.fixed(width: 400, height: 250))
    }
}
