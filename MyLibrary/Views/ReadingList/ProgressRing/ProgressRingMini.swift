//
//  ProgressRingMini.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 30/3/22.
//

import SwiftUI

struct ProgressRingMini: View {
    let book: NowReading
    
	var body: some View {
		Gauge(value: Float(book.progress), in: 0...100) {
			Text("\(book.progress)%")
		}
		.gaugeStyle(.accessoryCircularCapacity)
		.tint(book.isOnReading ? (book.progress > 75 ? .green : book.progress > 50 ? .yellow : book.progress > 25 ? .orange : .red) : .gray.opacity(0.8))
	}
}

struct ProgressRingMini_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingMini(book: NowReading.example[0])
    }
}
