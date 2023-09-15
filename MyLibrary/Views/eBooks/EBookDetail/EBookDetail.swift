//
//  EBookDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 2/1/22.
//

import SwiftUI

struct EBookDetail: View {
    @EnvironmentObject var model: UserViewModel
    
    @Binding var ebook: EBooks
    @State var newStatus: ReadingStatus
    
    @State var showingEditPage = false
    @State var showingInfoAlert = false
    @State var titleInfoAlert = ""
    @State var messageInfoAlert = ""
    
    @State var showingDeleteAlert = false
    @State var showingRDDetail = false
    @State var showingRSDetail = false
    @State var showingAddWaitingList = false
    @State var isOnWaitingList = false
    
    var body: some View {
        VStack {
			if let cover = ebook.cover {
				Image(uiImage: getCoverImage(from: cover))
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
            .modifier(EBookDetailModifier(showingDeleteAlert: $showingDeleteAlert, showingEditPage: $showingEditPage, showingInfoAlert: $showingInfoAlert, showingRDDetail: $showingRDDetail, showingRSDetail: $showingRDDetail, ebook: ebook, titleInfoAlert: titleInfoAlert, messageInfoAlert: messageInfoAlert))
            
            if showingEditPage {
                editView
            }
        }
        .sheet(isPresented: $showingAddWaitingList) {
            NavigationView {
                AddReading(bookTitle: ebook.bookTitle, synopsis: ebook.synopsis ?? "Sinopsis no disponible.", formatt: .kindle)
            }
        }
        .onAppear {
			isOnWaitingList = model.user.nowReading.contains(where: { $0.bookTitle == ebook.bookTitle }) ||
			model.user.nowWaiting.contains(where: { $0.bookTitle == ebook.bookTitle })
        }
    }
}

struct EBookDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EBookDetail(ebook: .constant(EBooks.dataTest), newStatus: .consulting)
                .environmentObject(UserViewModel())
        }
    }
}
