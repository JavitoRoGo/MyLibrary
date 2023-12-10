//
//  EBookMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct EBookMainView: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
	
	var areStatsDisabled: Bool {
		model.userLogic.user.ebooks.isEmpty
	}
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
					EachMainViewButton(iconImage: "book.circle.fill", iconColor: .pink, number: model.userLogic.user.ebooks.count, title: "Todos", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .all))
                    HStack(spacing: 15) {
						EachMainViewButton(iconImage: "paperclip", iconColor: .blue, number: model.userLogic.numberOfEbooksByStatus(.registered), title: "Registrados", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .registered))
						EachMainViewButton(iconImage: "book", iconColor: .green, number: model.userLogic.numberOfEbooksByStatus(.read), title: "Leídos", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .read))
                    }
                    HStack(spacing: 15) {
						EachMainViewButton(iconImage: "eyes", iconColor: .orange, number: model.userLogic.numberOfEbooksByStatus(.reading), title: "Leyendo", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .reading))
						EachMainViewButton(iconImage: "hourglass", iconColor: .primary.opacity(0.8), number: model.userLogic.numberOfEbooksByStatus(.waiting), title: "En espera", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .waiting))
                    }
                    HStack(spacing: 15) {
						EachMainViewButton(iconImage: "bookmark.slash.fill", iconColor: .red, number: model.userLogic.numberOfEbooksByStatus(.notRead), title: "No leídos", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .notRead))
						EachMainViewButton(iconImage: "text.book.closed.fill", iconColor: .brown, number: model.userLogic.numberOfEbooksByStatus(.consulting), title: "Consultas", destination: EBookList(customPreferredGridView: preferences.preferredGridView, filter: .consulting))
                    }
                    ScrollByOwner(format: .ebook)
                    
                    EachMainViewButton(iconImage: "chart.xyaxis.line", iconColor: .mint, number: 0, title: "Estadísticas", destination: EbookStatsView())
						.disabled(areStatsDisabled)
						.foregroundColor(areStatsDisabled ? .secondary.opacity(0.2) : .primary)
                }
                .foregroundColor(.primary)
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
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
