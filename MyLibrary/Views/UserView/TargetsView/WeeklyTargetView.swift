//
//  WeeklyTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct WeeklyTargetView: View {
	
    @Binding var weeklyTarget: DWTarget
    @State var pages = 250
    @State var hour = 7
    @State var minute = 0
    
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
			.modifier(WeeklyTargetModifier(pages: $pages, weeklyTarget: weeklyTarget, duration: duration, isDisabled: isDisabled))
        }
    }
}

struct WeeklyTargetView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyTargetView(weeklyTarget: .constant(.time))
			.environment(GlobalViewModel.preview)
    }
}
