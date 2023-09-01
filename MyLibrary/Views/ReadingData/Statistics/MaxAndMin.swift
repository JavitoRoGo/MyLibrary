//
//  MaxAndMin.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/22.
//

import Charts
import SwiftUI

struct MaxAndMin: View {
    @EnvironmentObject var model: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var datas: [DataForMaxMinChart] = []
    @State private var currentActiveItem: DataForMaxMinChart?
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Mínimo:")
                        .bold()
                    Text("\(minOfMin, format: .number) - \(maxOfMin, format: .number)")
                        .font(.title.bold())
                }
                .foregroundColor(colorScheme == .light ? .black : .white.opacity(0.5))
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Máximo:")
                        .bold()
                    Text("\(maxOfMax, format: .number) - \(minOfMax, format: .number)")
                        .font(.title.bold())
                }
                .foregroundColor(colorScheme == .light ? .red : .red.opacity(0.5))
            }
            .padding(.horizontal)
            
            Chart(datas, id: \.book) { data in
                BarMark(
                    x: .value("Datos", data.animate ? data.maxValue : 0),
                    y: .value("Libro", data.book)
                )
                .foregroundStyle(colorScheme == .light ? .red : .red.opacity(0.5))
                
                BarMark(
                    x: .value("Datos", data.animate ? -data.minValue : 0),
                    y: .value("Libro", data.book)
                )
                .foregroundStyle(colorScheme == .light ? .black : .white.opacity(0.5))
                
                if let currentActiveItem, currentActiveItem.book == data.book {
                    RuleMark(y: .value("Libro", currentActiveItem.book))
                        .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                        .annotation(alignment: .topTrailing) {
                            VStack(alignment: .trailing, spacing: 5) {
                                Text(currentActiveItem.book)
                                    .font(.caption.bold())
                                    .foregroundColor(.gray)
                                Text("\(currentActiveItem.minValue) - \(currentActiveItem.maxValue)")
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                        }
                }
            }
            .chartYAxis(.hidden)
            .chartXAxis(.hidden)
            .chartOverlay { proxy in
                GeometryReader { _ in
                    Rectangle()
                        .fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let location = value.location
                                    if let bookTitle: String = proxy.value(atY: location.y) {
                                        if let currentItem = datas.first(where: { item in
                                            item.book == bookTitle }) {
                                            self.currentActiveItem = currentItem
                                        }
                                    }
                                }.onEnded { value in
                                    self.currentActiveItem = nil
                                }
                        )
                }
            }
        }
        .modifier(MaxAndMinModifier())
        .task {
            datas = model.getMaxAndMinPagesPerBook()
            animateGraph()
        }
    }
}

struct MaxAndMin_Previews: PreviewProvider {
    static var previews: some View {
        MaxAndMin()
            .environmentObject(UserViewModel())
    }
}
