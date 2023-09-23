//
//  DailyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/1/23.
//

import SwiftUI

struct DailyTargetView: View {
    @Binding var dailyTarget: DWTarget
    @State var pages = 40
    @State var hour = 1
    @State var minute = 0
    
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
			.modifier(DailyTargetModifier(pages: $pages, dailyTarget: dailyTarget, duration: duration, isDisabled: isDisabled))
        }
    }
}

struct DailyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTargetView(dailyTarget: .constant(.pages))
			.environmentObject(GlobalViewModel.preview)
    }
}
