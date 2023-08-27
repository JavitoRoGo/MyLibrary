//
//  EBookStatsValuePicker.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension EbookStatsView {
	var valuePicker: some View {
		VStack {
			Picker("Categoría", selection: $statsSelection) {
				ForEach(titles.indices, id:\.self) { index in
					Text(titles[index])
				}
			}
			.pickerStyle(.segmented)
			.padding(.horizontal)
			
			VStack {
				Text("Pulsa para elegir un valor")
					.font(.footnote)
				ZStack {
					Button {
						withAnimation {
							showingPicker = true
						}
					} label: {
						Text(pickerSelection)
							.font(.title2)
							.foregroundColor(.white)
							.frame(width: 400, height: 40)
							.background(.blue)
							.cornerRadius(20)
					}
					if showingPicker {
						VStack {
							HStack {
								Spacer()
								Button("Listo") {
									withAnimation {
										showingPicker = false
									}
								}
								.padding()
							}
							Picker("Valor", selection: $pickerSelection) {
								ForEach(model.arrayOfEbookLabelsByCategoryForPickerAndGraph(tag: statsSelection), id: \.self) {
									Text($0)
								}
							}
							.pickerStyle(.wheel)
						}
						.background(Color(UIColor.systemGray2))
						.opacity(1)
						.transition(.opacity)
					}
				}
				HStack {
					Spacer()
					Text("eBooks:")
						.font(.title3)
					Spacer()
					Text(String(model.numOfEBooksForStats(tag: statsSelection, text: pickerSelection)))
						.font(.largeTitle)
						.frame(width: 75, height: 55)
						.background(.orange)
						.cornerRadius(15)
						.overlay {
							RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 2)
						}
						.shadow(color: .black, radius: 5)
					Spacer()
				}
				.padding(.top, 30)
			}
			.padding(.top, 15)
		}
	}
}
