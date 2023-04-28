//
//  MonthlyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct MonthlyTargetView: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var monthlyTarget: MYTarget
    @State private var books = 4
    @State private var pages = 1000
    
    var isDisabled: Bool {
        switch monthlyTarget {
        case .pages:
            if pages != 0 {
                return false
            }
        case .books:
            if books != 0 {
                return false
            }
        }
        return true
    }
    
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
            .navigationTitle("Objetivo mensual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if monthlyTarget == .pages {
                            model.monthlyPagesTarget = pages
                        } else {
                            model.monthlyBooksTarget = books
                        }
                        dismiss()
                    }
                    .disabled(isDisabled)
                }
            }
            .task {
                books = model.monthlyBooksTarget
                pages = model.monthlyPagesTarget
            }
        }
    }
}

struct MonthlyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyTargetView(monthlyTarget: .constant(.books))
            .environmentObject(UserViewModel())
    }
}
