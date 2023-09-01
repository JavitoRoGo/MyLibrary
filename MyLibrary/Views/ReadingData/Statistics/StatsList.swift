//
//  StatsList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/4/22.
//

import SwiftUI

struct StatsList: View {
    @EnvironmentObject var model: UserViewModel
    let tag: Int
    let colors: [Color]
    var topRange: Int {
        if tag == 3 {
            return Formatt.allCases.count
        } else if tag == 4 {
            return 5
        } else {
			return model.user.bookFinishingYears.count
        }
    }
    var datas: ([String], [Int]) {
        model.datas(tag: tag)
    }
    
    var body: some View {
        if tag == 3 {
            List(0..<topRange, id: \.self) { index in
                HStack {
                    Capsule()
                        .fill(colors[index])
                        .frame(width: 20, height: 8)
                    Text(datas.0[index])
                    Spacer()
                    Text("\(datas.1[index]) libros")
                }
            }
        } else if tag == 4 {
            List(0..<topRange, id: \.self) { index in
                HStack {
                    Capsule()
                        .fill(colors[index])
                        .frame(width: 20, height: 8)
                    RDStars(rating: .constant(index + 1))
                    Spacer()
                    Text("\(datas.1[index]) libros")
                }
            }
        } else {
            List(0..<topRange, id: \.self) { index in
                HStack {
                    Capsule()
                        .fill(colors[index])
                        .frame(width: 20, height: 8)
                    Text(datas.0[index])
                    Spacer()
                    if tag == 0 {
                        Text("\(datas.1[index]) libros")
                    } else if tag == 1 {
                        Text("\(datas.1[index]) páginas")
                    } else if tag == 2 {
                        Text("\(datas.1[index]) pág/día")
                    }
                }
            }
        }
    }
}

struct StatsList_Previews: PreviewProvider {
    static let colors: [Color] = [.red, .orange, .blue, .green, .yellow]
    
    static var previews: some View {
        StatsList(tag: 0, colors: colors)
            .environmentObject(UserViewModel())
    }
}
