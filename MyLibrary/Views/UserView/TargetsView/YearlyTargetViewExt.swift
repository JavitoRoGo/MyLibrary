//
//  YearlyTargetViewExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 11/8/23.
//

import SwiftUI

extension YearlyTargetView {
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
	
	struct YearlyTargetModifier: ViewModifier {
		@EnvironmentObject var model: GlobalViewModel
		@Environment(\.dismiss) var dismiss
		
		@Binding var books: Int
		@Binding var pages: Int
		
		let yearlyTarget: MYTarget
		let isDisabled: Bool
		
		func body(content: Content) -> some View {
			content
				.navigationTitle("Objetivo anual")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarTrailing) {
						Button("Guardar") {
							if yearlyTarget == .pages {
								model.userLogic.yearlyPagesTarget = pages
							} else {
								model.userLogic.yearlyBooksTarget = books
							}
							dismiss()
						}
						.disabled(isDisabled)
					}
				}
				.task {
					books = model.userLogic.yearlyBooksTarget
					pages = model.userLogic.yearlyPagesTarget
				}
		}
	}
}
