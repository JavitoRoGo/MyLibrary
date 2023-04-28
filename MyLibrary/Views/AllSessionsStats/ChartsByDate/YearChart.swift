//
//  YearChart.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/10/22.
//

import Charts
import SwiftUI

struct YearChart: View {
    @EnvironmentObject var model: ReadingSessionModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var isLineGraph: Bool
    @State private var animateDatas: [DataStructForAnimateGraph<Int,String>] = []
    
    var pages: [Int] {
        model.calcTotalPagesPerMonth().pages
    }
    var months: [String] {
        model.calcTotalPagesPerMonth().months
    }
    var max: Int {
        pages.max() ?? 0
    }
    
    // Propiedades para mostrar los datos en la gráfica al hacer el gesto de arrastrar
    @State private var currentActiveItem: DataStructForAnimateGraph<Int,String>?
    @State private var plotLocationX: CGFloat = 0
    
    var body: some View {
        Chart(animateDatas) { data in
            if isLineGraph {
                LineMark(
                    x: .value("Fecha", data.label),
                    y: .value("Páginas", data.animate ? data.value : 0)
                )
                .interpolationMethod(.catmullRom)
                AreaMark(
                    x: .value("Fecha", data.label),
                    y: .value("Páginas", data.animate ? data.value : 0)
                )
                .foregroundStyle(.blue.opacity(0.2))
                .interpolationMethod(.catmullRom)
            } else {
                BarMark(
                    x: .value("Fecha", data.label),
                    y: .value("Páginas", data.animate ? data.value : 0)
                )
            }
            
            if let currentActiveItem, currentActiveItem.id == data.id {
                RuleMark(x: plotLocationX, yStart: .value("inicio", 0), yEnd: .value("Fin", max + 500))
                    .lineStyle(.init(lineWidth: 2, miterLimit: 2, dash: [2], dashPhase: 5))
                    .annotation(position: .top) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Páginas")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(currentActiveItem.value, format: .number)
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .fill(.white.shadow(.drop(radius: 2)))
                        }
                    }
            }
        }
        // Configuración del gesto para mostrar los valores
        .chartOverlay { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                // Getting current location
                                let location = value.location
                                // Extracting value from the location
                                if let monthString: String = proxy.value(atX: location.x) {
                                    if let currentItem = animateDatas.first(where: { item in
                                        item.label == monthString }) {
                                        self.currentActiveItem = currentItem
                                        self.plotLocationX = location.x
                                    }
                                }
                            }
                            .onEnded { value in
                                self.currentActiveItem = nil
                            }
                    )
            }
        }
        .chartYScale(domain: 0...(max + 500))
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
        .task {
            animateDatas = getValuesIntoDataArrayForAnimateGraph(pages, months)
            animateGraph()
        }
    }
    
    func animateGraph() {
        for (index, _) in animateDatas.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animateDatas[index].animate = true
                }
            }
        }
    }
}

struct YearChart_Previews: PreviewProvider {
    static var previews: some View {
        YearChart(isLineGraph: .constant(false))
    }
}
