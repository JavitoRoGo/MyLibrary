//
//  MonthChart.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/10/22.
//

import Charts
import SwiftUI

struct MonthChart: View {
    @EnvironmentObject var model: GlobalViewModel
    @Environment(\.colorScheme) var colorScheme
    @Binding var isLineGraph: Bool
    @State private var animateDatas : [DataStructForAnimateGraph<Int,Date>] = []
    
    var pages: [Int] {
		model.userLogic.calcTotalPagesPerWeekAndMonth(tag: 1).pages
    }
    var days: [Date] {
		model.userLogic.calcTotalPagesPerWeekAndMonth(tag: 1).days
    }
    
    // Propiedades para mostrar los datos en la gráfica al hacer el gesto de arrastrar
    @State private var currentActiveItem: DataStructForAnimateGraph<Int,Date>?
    
    var body: some View {
        Chart(animateDatas) { data in
            if isLineGraph {
                LineMark(
                    x: .value("Fecha", data.label, unit: .day),
                    y: .value("Páginas", data.animate ? data.value : 0)
                )
                .interpolationMethod(.catmullRom)
                AreaMark(
                    x: .value("Fecha", data.label, unit: .day),
                    y: .value("Páginas", data.animate ? data.value : 0)
                )
                .foregroundStyle(.blue.opacity(0.2))
                .interpolationMethod(.catmullRom)
            } else {
                BarMark(
                    x: .value("Fecha", data.label, unit: .day),
                    y: .value("Páginas", data.animate ? data.value : 0)
                )
                .foregroundStyle(.blue.gradient)
            }
            
            if let currentActiveItem, currentActiveItem.id == data.id {
                RuleMark(x: .value("Día", currentActiveItem.label))
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
        .chartXAxis {
            AxisMarks() { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.day())
            }
        }
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
                                if let date: Date = proxy.value(atX: location.x) {
                                    // Extracting day
                                    let calendar = Calendar.current
                                    let day = calendar.component(.day, from: date)
                                    if let currentItem = animateDatas.first(where: { item in
                                        calendar.component(.day, from: item.label) == day }) {
                                        self.currentActiveItem = currentItem
                                    }
                                }
                            }
                            .onEnded { value in
                                self.currentActiveItem = nil
                            }
                    )
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
        .task {
            animateDatas = getValuesIntoDataArrayForAnimateGraph(pages, days)
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

struct MonthChart_Previews: PreviewProvider {
    static var previews: some View {
        MonthChart(isLineGraph: .constant(false))
			.environmentObject(GlobalViewModel.preview)
    }
}
