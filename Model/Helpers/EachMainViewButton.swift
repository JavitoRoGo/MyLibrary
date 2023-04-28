//
//  EachMainViewButton.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/12/22.
//

import SwiftUI

struct EachMainViewButton<Content: View>: View {
    let iconImage: String
    let iconColor: Color
    let number: Int
    let title: String
    let destination: Content
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: iconImage)
                        .font(.title)
                        .foregroundColor(iconColor)
                    Spacer()
                    if number != 0 {
                        Text(number, format: .number)
                    }
                }
                Text(title)
            }
            .font(.title3.bold())
        }
        .padding()
        .background(ButtonBackground())
    }
}

struct EachMainViewButton_Previews: PreviewProvider {
    static var previews: some View {
        EachMainViewButton(iconImage: "person", iconColor: .pink, number: 69, title: "Todos", destination: EmptyView())
    }
}


struct ButtonBackground: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(colorScheme == .light ? .white : .gray.opacity(0.3))
    }
}
