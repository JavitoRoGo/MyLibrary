//
//  YearlyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct YearlyTargetView: View {
    @EnvironmentObject var model: UserViewModel
    
    @Binding var yearlyTarget: MYTarget
    @State var books = 40
    @State var pages = 8000
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("target", selection: $yearlyTarget.animation()) {
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
                    .foregroundColor(yearlyTarget == .books ? .primary : .secondary.opacity(0.4))
                    .disabled(yearlyTarget == .pages)
                    Section {
                        HStack {
                            Text("Páginas")
                            Spacer()
                            TextField("", value: $pages, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .foregroundColor(yearlyTarget == .pages ? .primary : .secondary.opacity(0.4))
                    .disabled(yearlyTarget == .books)
                }
            }
			.modifier(YearlyTargetModifier(books: $books, pages: $pages, yearlyTarget: yearlyTarget, isDisabled: isDisabled))
        }
    }
}

struct YearlyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyTargetView(yearlyTarget: .constant(.books))
            .environmentObject(UserViewModel())
    }
}
