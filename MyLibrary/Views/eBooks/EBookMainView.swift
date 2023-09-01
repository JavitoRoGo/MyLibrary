//
//  EBookMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct EBookMainView: View {
    @EnvironmentObject var model: UserViewModel
	
	var areStatsDisabled: Bool {
		model.user.ebooks.isEmpty
	}
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 15) {
					EachMainViewButton(iconImage: "book.circle.fill", iconColor: .pink, number: model.user.ebooks.count, title: "Todos", destination: EBookList(filter: .all))
                    HStack(spacing: 15) {
                        EachMainViewButton(iconImage: "paperclip", iconColor: .blue, number: model.numberOfEbooksByStatus(.registered), title: "Registrados", destination: EBookList(filter: .registered))
                        EachMainViewButton(iconImage: "book", iconColor: .green, number: model.numberOfEbooksByStatus(.read), title: "Leídos", destination: EBookList(filter: .read))
                    }
                    HStack(spacing: 15) {
                        EachMainViewButton(iconImage: "eyes", iconColor: .orange, number: model.numberOfEbooksByStatus(.reading), title: "Leyendo", destination: EBookList(filter: .reading))
                        EachMainViewButton(iconImage: "hourglass", iconColor: .primary.opacity(0.8), number: model.numberOfEbooksByStatus(.waiting), title: "En espera", destination: EBookList(filter: .waiting))
                    }
                    HStack(spacing: 15) {
                        EachMainViewButton(iconImage: "bookmark.slash.fill", iconColor: .red, number: model.numberOfEbooksByStatus(.notRead), title: "No leídos", destination: EBookList(filter: .notRead))
                        EachMainViewButton(iconImage: "text.book.closed.fill", iconColor: .brown, number: model.numberOfEbooksByStatus(.consulting), title: "Consultas", destination: EBookList(filter: .consulting))
                    }
                    ScrollByOwner(format: .ebook)
                    
                    EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .mint, number: 0, title: "Estadísticas", destination: EbookStatsView())
						.disabled(areStatsDisabled)
						.foregroundColor(areStatsDisabled ? .secondary.opacity(0.2) : .primary)
                }
                .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .background {
                Color.secondary.opacity(0.1)
                    .ignoresSafeArea()
            }
            .navigationTitle("eBooks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EBookConfigView()) {
                        Label("Configuración", systemImage: "gearshape")
                    }
                }
            }
        }
    }
}

struct EBookMainView_Previews: PreviewProvider {
    static var previews: some View {
        EBookMainView()
            .environmentObject(UserViewModel())
    }
}
