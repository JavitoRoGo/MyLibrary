//
//  ActualReadingDetailList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/8/23.
//

import SwiftUI

extension ActualReadingDetail {
	var dataList: some View {
		List {
			HStack {
				Text("Siguiente página")
				Spacer()
				Text("\(book.nextPage)")
			}
			HStack {
				Text("Tiempo de lectura")
				Spacer()
				Text(book.readingTime)
			}
			HStack {
				Text("Tiempo restante")
				Spacer()
				Text(!book.isFinished ? book.remainingTime.minPerDayDoubleToString : "0min")
			}
			HStack {
				Text("Puedes terminar...")
				Spacer()
				Text(!book.isFinished ? book.finishingDay.formatted(date: .numeric, time: .omitted) : "-")
			}
			
			Section {
				NavigationLink(destination: RSList(book: book)) {
					HStack {
						Text("Sesiones")
						Spacer()
						Text("\(book.sessions.count)")
					}
				}
			}
			
			Section {
				HStack {
					Text("Tiempo / página")
					Spacer()
					Text(book.minPerPag)
				}
				HStack {
					Text("Tiempo / sesión")
					Spacer()
					Text(book.minPerDay)
				}
				HStack {
					Text("Páginas / sesión")
					Spacer()
					Text(book.pagesPerDay, format: .number)
				}
			}
			
			Section {
				Text(book.synopsis)
			}
		}
	}
}
