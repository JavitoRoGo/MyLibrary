//
//  DailyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/1/23.
//

import SwiftUI

struct DailyTargetView: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var dailyTarget: DWTarget
    @State private var pages = 40
    @State private var hour = 1
    @State private var minute = 0
    
    var duration: Double {
        Double(hour) + Double(minute)/60
    }
    var isDisabled: Bool {
        switch dailyTarget {
        case .pages:
            if pages != 0 {
                return false
            }
        case .time:
            if duration > 0 {
                return false
            }
        }
        return true
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("target", selection: $dailyTarget.animation()) {
                    ForEach(DWTarget.allCases, id:\.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                Form {
                    Section {
                        HStack {
                            Text("Páginas")
                            Spacer()
                            TextField("", value: $pages, format: .number)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    .foregroundColor(dailyTarget == .pages ? .primary : .secondary.opacity(0.4))
                    .disabled(dailyTarget == .time)
                    Section {
                        HStack {
                            Text("Tiempo")
                            Spacer()
                            Picker("hora", selection: $hour) {
                                ForEach(0..<5) {
                                    Text("\($0) h")
                                }
                            }
                            Picker("minuto", selection: $minute) {
                                ForEach(0..<60) {
                                    Text("\($0) m")
                                }
                            }
                        }
                        .labelsHidden()
                    }
                    .foregroundColor(dailyTarget == .time ? .primary : .secondary.opacity(0.4))
                    .disabled(dailyTarget == .pages)
                }
            }
            .navigationTitle("Objetivo diario")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if dailyTarget == .pages {
                            model.dailyPagesTarget = pages
                        } else {
                            model.dailyTimeTarget = duration
                        }
                        dismiss()
                    }
                    .disabled(isDisabled)
                }
            }
            .task {
                pages = model.dailyPagesTarget
            }
        }
    }
}

struct DailyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTargetView(dailyTarget: .constant(.pages))
            .environmentObject(UserViewModel())
    }
}
