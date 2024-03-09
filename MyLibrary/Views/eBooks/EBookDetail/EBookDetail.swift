//
//  EBookDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookDetail: View {
    @Environment(GlobalViewModel.self) var model
    
    @Binding var ebook: EBooks
    
    @State var showingEditPage = false
    @State var showingInfoAlert = false
    @State var titleInfoAlert = ""
    @State var messageInfoAlert = ""
    
    @State var showingDeleteAlert = false
    @State var showingRDDetail = false
    @State var showingRSDetail = false
    
    var body: some View {
        VStack {
			if let cover = ebook.cover,
			   let uiimage = getCoverImage(from: cover) {
				Image(uiImage: uiimage)
					.resizable()
					.modifier(RDCoverModifier(width: 120, height: 150, cornerRadius: 30, lineWidth: 4))
			}
			
            List {
                authorSection
                
                yearSection
                
                Section {
                    HStack {
                        Text("Propietario:")
                            .font(.subheadline)
                        Spacer()
                        Text(ebook.owner)
                            .font(.headline)
                    }
                }
                
                Section {
                    if let text = ebook.synopsis {
                        Text(text)
                    } else {
                        Text("Sinopsis no disponible.")
                    }
                }
            }
            .modifier(EBookDetailModifier(showingDeleteAlert: $showingDeleteAlert, showingEditPage: $showingEditPage, showingInfoAlert: $showingInfoAlert, showingRDDetail: $showingRDDetail, showingRSDetail: $showingRDDetail, ebook: $ebook, titleInfoAlert: titleInfoAlert, messageInfoAlert: messageInfoAlert))
        }
    }
}

struct EBookDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EBookDetail(ebook: .constant(EBooks.example[0]))
				.environment(GlobalViewModel.preview)
        }
    }
}
