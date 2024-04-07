//
//  StatsList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/4/22.
//

import SwiftUI

struct StatsList: View {
    @Environment(GlobalViewModel.self) var model
	let datas: [SectorChartData]
    let tag: Int
    var topRange: Int {
        if tag == 3 {
            return Formatt.allCases.count
        } else if tag == 4 {
            return 5
        } else {
			return model.userLogic.user.bookFinishingYears.count
        }
    }
    
    var body: some View {
        if tag == 3 {
            List(0..<topRange, id: \.self) { index in
                HStack {
                    Capsule()
						.fill(datas[index].color)
                        .frame(width: 20, height: 8)
					Text(datas[index].label)
                    Spacer()
					Text("\(datas[index].data) libros")
                }
            }
        } else if tag == 4 {
            List(0..<topRange, id: \.self) { index in
                HStack {
                    Capsule()
						.fill(datas[index].color)
                        .frame(width: 20, height: 8)
                    RDStars(rating: .constant(index + 1))
                    Spacer()
					Text("\(datas[index].data) libros")
                }
            }
        } else {
            List(0..<topRange, id: \.self) { index in
                HStack {
                    Capsule()
						.fill(datas[index].color)
                        .frame(width: 20, height: 8)
					Text(datas[index].label)
                    Spacer()
                    if tag == 0 {
						Text("\(datas[index].data) libros")
                    } else if tag == 1 {
						Text("\(datas[index].data) páginas")
                    } else if tag == 2 {
						Text("\(datas[index].data) pág/día")
                    }
                }
            }
        }
    }
}

struct StatsList_Previews: PreviewProvider {
	static let datas: [SectorChartData] = [
		.init(label: "10", data: 10, color: .red),
		.init(label: "20", data: 20, color: .orange),
		.init(label: "30", data: 30, color: .green),
		.init(label: "40", data: 40, color: .blue),
		.init(label: "50", data: 50, color: .purple)
	]
    
    static var previews: some View {
		StatsList(datas: datas, tag: 0)
			.environment(GlobalViewModel.preview)
    }
}
