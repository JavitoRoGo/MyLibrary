//
//  MonthlyTargetViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension MonthlyTargetView {
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
	
	struct MonthlyTargetModifier: ViewModifier {
		@EnvironmentObject var model: GlobalViewModel
		@Environment(\.dismiss) var dismiss
		
		@Binding var books: Int
		@Binding var pages: Int
		
		let monthlyTarget: MYTarget
		let isDisabled: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Objetivo mensual")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Guardar") {
							if monthlyTarget == .pages {
								model.userLogic.monthlyPagesTarget = pages
							} else {
								model.userLogic.monthlyBooksTarget = books
							}
							dismiss()
						}
						.disabled(isDisabled)
					}
				}
				.task {
					books = model.userLogic.monthlyBooksTarget
					pages = model.userLogic.monthlyPagesTarget
				}
		}
	}
}
