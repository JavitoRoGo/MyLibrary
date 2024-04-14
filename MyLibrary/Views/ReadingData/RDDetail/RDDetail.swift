//
//  RDDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDDetail: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    
    @State var rdata: ReadingData
    @State var showingLocation = false
    @State var showingEditView = false
	@State var openingProgress: CGFloat = 0
    
    var body: some View {
        VStack {
            RDScroll(rdata: $rdata, openningProgress: $openingProgress)
            
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
            .modifier(RDDetailModifier(rdata: $rdata, showingLocation: $showingLocation, showingEditView: $showingEditView, isThereALocation: isThereALocation))
        }
    }
}

struct RDDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
			RDDetail(rdata: ReadingData.example[0])
				.environment(GlobalViewModel.preview)
				.environmentObject(UserPreferences())
        }
    }
}
