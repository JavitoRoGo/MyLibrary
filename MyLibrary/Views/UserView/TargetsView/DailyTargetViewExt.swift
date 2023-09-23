//
//  DailyTargetViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension DailyTargetView {
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
	
	struct DailyTargetModifier: ViewModifier {
		@EnvironmentObject var model: GlobalViewModel
		@Environment(\.dismiss) var dismiss
		
		@Binding var pages: Int
		let dailyTarget: DWTarget
		let duration: Double
		let isDisabled: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Objetivo diario")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Guardar") {
							if dailyTarget == .pages {
								model.userLogic.dailyPagesTarget = pages
							} else {
								model.userLogic.dailyTimeTarget = duration
							}
							dismiss()
						}
						.disabled(isDisabled)
					}
				}
				.task {
					pages = model.userLogic.dailyPagesTarget
				}
		}
	}
}
