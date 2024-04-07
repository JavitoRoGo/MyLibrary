//
//  RingTargetView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 13/1/23.
//

import SwiftUI

struct RingTargetView: View {
    let color: Color
    let value: Int
    let target: Int
	var dwTarget: DWTarget?
	var myTarget: MYTarget?
	
	var imageName: String {
		if let dwTarget {
			switch dwTarget {
				case .pages:
					return "book.pages"
				case .time:
					return "hourglass"
			}
		}
		if let myTarget {
			switch myTarget {
				case .books:
					return "books.vertical"
				case .pages:
					return "book.pages"
			}
		}
		return ""
	}
    
	var body: some View {
		Gauge(value: Float(value), in: 0...Float(target)) { 
			Image(systemName: imageName)
				.foregroundStyle(color.opacity(0.8))
		}
		.gaugeStyle(.accessoryCircularCapacity)
		.tint(color)
	}
}

struct RingTargetView_Previews: PreviewProvider {
    static var previews: some View {
		RingTargetView(color: .red, value: 15, target: 40, dwTarget: .pages)
    }
}
