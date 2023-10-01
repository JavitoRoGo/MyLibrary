//
//  MonthlyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct MonthlyTargetView: View {
    @Binding var monthlyTarget: MYTarget
    @State var books = 4
    @State var pages = 1000
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("target", selection: $monthlyTarget.animation()) {
                    ForEach(MYTarget.allCases, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                Form {
                    Section {
                        HStack {
                            Text("Libros")
                            Spacer()
                            TextField("", value: $books, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .foregroundColor(monthlyTarget == .books ? .primary : .secondary.opacity(0.4))
                    .disabled(monthlyTarget == .pages)
                    Section {
                        HStack {
                            Text("Páginas")
                            Spacer()
                            TextField("", value: $pages, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .foregroundColor(monthlyTarget == .pages ? .primary : .secondary.opacity(0.4))
                    .disabled(monthlyTarget == .books)
                }
            }
			.modifier(MonthlyTargetModifier(books: $books, pages: $pages, monthlyTarget: monthlyTarget, isDisabled: isDisabled))
        }
    }
}

struct MonthlyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyTargetView(monthlyTarget: .constant(.books))
			.environment(GlobalViewModel.preview)
    }
}
