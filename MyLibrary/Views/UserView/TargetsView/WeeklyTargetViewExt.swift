//
//  WeeklyTargetViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension WeeklyTargetView {
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
	
	struct WeeklyTargetModifier: ViewModifier {
		@Environment(GlobalViewModel.self) var model
		@EnvironmentObject var preferences: UserPreferences
		@Environment(\.dismiss) var dismiss
		
		@Binding var pages: Int
		let weeklyTarget: DWTarget
		let duration: Double
		let isDisabled: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Objetivo semanal")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Guardar") {
							if weeklyTarget == .pages {
								preferences.weeklyPagesTarget = pages
							} else {
								preferences.weeklyTimeTarget = duration
							}
							dismiss()
						}
						.disabled(isDisabled)
					}
				}
				.task {
					pages = preferences.weeklyPagesTarget
				}
		}
	}
}
