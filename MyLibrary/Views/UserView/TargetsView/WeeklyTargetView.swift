//
//  WeeklyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct WeeklyTargetView: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var weeklyTarget: DWTarget
    @State private var pages = 250
    @State private var hour = 7
    @State private var minute = 0
    
    var duration: Double {
        Double(hour) + Double(minute)/60
    }
    var isDisabled: Bool {
        switch weeklyTarget {
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
                Picker("target", selection: $weeklyTarget.animation()) {
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
                    .foregroundColor(weeklyTarget == .pages ? .primary : .secondary.opacity(0.4))
                    .disabled(weeklyTarget == .time)
                    Section {
                        HStack {
                            Text("Tiempo")
                            Spacer()
                            Picker("hora", selection: $hour) {
                                ForEach(0..<31) {
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
                    .foregroundColor(weeklyTarget == .time ? .primary : .secondary.opacity(0.4))
                    .disabled(weeklyTarget == .pages)
                }
            }
            .navigationTitle("Objetivo semanal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if weeklyTarget == .pages {
                            model.weeklyPagesTarget = pages
                        } else {
                            model.weeklyTimeTarget = duration
                        }
                        dismiss()
                    }
                    .disabled(isDisabled)
                }
            }
            .task {
                pages = model.weeklyPagesTarget
            }
        }
    }
}

struct WeeklyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyTargetView(weeklyTarget: .constant(.time))
            .environmentObject(UserViewModel())
    }
}
