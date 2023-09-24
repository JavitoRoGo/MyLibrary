//
//  RDDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDDetail: View {
    @Environment(GlobalViewModel.self) var model
    
    @State var rdata: ReadingData
    @State var showingLocation = false
    @State var showingEditView = false
    @State var showingCommentsAlert = false
    
    var body: some View {
        VStack {
            RDScroll(rdata: $rdata)
            
            List {
                titleSection
                
                dataSection
                
                compareSection
                
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Formato:")
                                .font(.subheadline)
                            Text(rdata.formatt.rawValue)
                                .font(.headline)
                        }
                        Spacer()
                        VStack {
                            Text("Valoración:")
                                .font(.subheadline)
                            RDStars(rating: .constant(rdata.rating))
                        }
                    }
                }
                
                Section {
                    Text(rdata.synopsis)
                }
            }
            .modifier(RDDetailModifier(rdata: $rdata, showingLocation: $showingLocation, showingEditView: $showingEditView, showingCommentsAlert: $showingCommentsAlert, isThereALocation: isThereALocation))
        }
    }
}

struct RDDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RDDetail(rdata: ReadingData.dataTest)
				.environment(GlobalViewModel.preview)
        }
    }
}
