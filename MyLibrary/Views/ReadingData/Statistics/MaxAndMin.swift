//
//  MaxAndMin.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/10/22.
//

import Charts
import SwiftUI

struct MaxAndMin: View {
    @EnvironmentObject var model: RDModel
    @Environment(\.colorScheme) var colorScheme
    @State private var datas: [DataForMaxMinChart] = []
    @State private var currentActiveItem: DataForMaxMinChart?
    
    var maxOfMax: Int {
        datas.max { item1, item2 in
            item2.maxValue > item1.maxValue
        }?.maxValue ?? 0
    }
    var minOfMax: Int {
        datas.min { item1, item2 in
            item1.maxValue < item2.maxValue
        }?.maxValue ?? 0
    }
    
    var minOfMin: Int {
        datas.min { item1, item2 in
            item1.minValue < item2.minValue
        }?.minValue ?? 0
    }
    var maxOfMin: Int {
        datas.max { item1, item2 in
            item2.minValue > item1.minValue
        }?.minValue ?? 0
    }
    
    var maxForXAxis: Int {
        datas.count + 1
    }
    
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
        .padding()
        .background {
            if colorScheme == .dark {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.gray.opacity(0.3).shadow(.drop(radius: 2)))
            } else {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 2)))
            }
        }
        .navigationTitle("Máximos y mínimos")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .task {
            datas = model.getMaxMinPerBook()
            animateGraph()
        }
    }
    
    func animateGraph() {
        for (index, _) in datas.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.02) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    datas[index].animate = true
                }
            }
        }
    }
}

struct MaxAndMin_Previews: PreviewProvider {
    static var previews: some View {
        MaxAndMin()
            .environmentObject(RDModel())
    }
}
