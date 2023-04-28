//
//  YearlyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct YearlyTargetView: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var yearlyTarget: MYTarget
    @State private var books = 40
    @State private var pages = 8000
    
    var isDisabled: Bool {
        switch yearlyTarget {
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
            .navigationTitle("Objetivo anual")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if yearlyTarget == .pages {
                            model.yearlyPagesTarget = pages
                        } else {
                            model.yearlyBooksTarget = books
                        }
                        dismiss()
                    }
                    .disabled(isDisabled)
                }
            }
            .task {
                books = model.yearlyBooksTarget
                pages = model.yearlyPagesTarget
            }
        }
    }
}

struct YearlyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyTargetView(yearlyTarget: .constant(.books))
            .environmentObject(UserViewModel())
    }
}
