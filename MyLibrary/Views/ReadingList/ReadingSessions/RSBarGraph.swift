//
//  RSBarGraph.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/6/22.
//

import Charts
import SwiftUI

struct RSBarGraph: View {
    let datas: [Double]
    let labels: [String]
    
    @State private var showingOldGraph = 0
    let buttons = ["SwiftCharts", "Clásica"]
    
    var body: some View {
        VStack {
            Picker("Elige gráfica", selection: $showingOldGraph.animation(.easeInOut)) {
                ForEach(0...1, id:\.self) { num in
                    Text(buttons[num])
                }
            }
            .pickerStyle(.segmented)
            .padding()
            if showingOldGraph == 0 {
                NewBarGraph(datas: datas, labels: labels)
            } else if showingOldGraph == 1 {
                OldBarGraph(datas: datas, labels: labels)
            }
        }
    }
}

struct RDBarGraph_Previews: PreviewProvider {
    static let datas = [25.0, 63.0, 11.0]
    static let labels = ["11/10", "10/10", "9/10"]
    
    static var previews: some View {
        RSBarGraph(datas: datas, labels: labels)
            .environmentObject(RDModel())
            .environmentObject(ReadingSessionModel())
    }
}


struct NewBarGraph: View {
    let datas: [Double]
    let labels: [String]
    
    @State private var newDatas: [DataStructForAnimateGraph<Double,String>] = []
        
    var body: some View {
        ScrollView {
            Chart(newDatas) { data in
                BarMark(
                    x: .value("Páginas", data.animate ? data.value : 0),
                    y: .value("Día", data.label)
                    )
                .foregroundStyle(data.value < 50 ? .blue : .green)
                .annotation(position: .trailing) {
                    Text(data.value.formatted())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .chartPlotStyle { plot in
                plot.background(.blue.opacity(0.1))
                .frame(height: 40 * CGFloat(newDatas.count))
            }
            .chartXAxis {
                AxisMarks(position: .top)
            }
        }
        .task {
            newDatas = getValuesIntoDataArrayForAnimateGraph(datas, labels)
            animateGraph(true)
        }
    }
    
    func animateGraph(_ fromChange: Bool = false) {
        for (index, _) in newDatas.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                    newDatas[index].animate = true
                }
            }
        }
    }
}


struct OldBarGraph: View {
    let datas: [Double]
    let labels: [String]
    var maxData: Double {
        datas.max() ?? 0
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack {
                    HStack(spacing: 15) {
                        ForEach(getGraphLines(), id: \.self) { line in
                            VStack(spacing: 8) {
                                Text(Int(line), format: .number)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .frame(height: 20)
                                Rectangle()
                                    .fill(.gray.opacity(0.2))
                                    .frame(width: 1)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .offset(x: 15)
                        }
                    }
                    
                    HStack(spacing: 0) {
                        VStack {
                            ForEach(datas.indices, id: \.self) { index in
                                Text(labels[index])
                                    .font(.caption)
                                    .foregroundColor(datas[index] >= 50 ? .green : .primary)
                                    .frame(width: 30, alignment: .leading)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        .offset(x: 10)
                        VStack(alignment: .leading) {
                            ForEach(datas.indices, id:\.self) { index in
                                AnimatedBarGraph(index: index, showOver50: showOver50(index: index))
                                    .frame(width: getBarWidth(point: datas[index], size: geo.size))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        }
                        .offset(x: -22)
                    }
                    .padding(.top, 30)
                }
            }
        }
    }
    
    func getGraphLines() -> [Double] {
        var lines: [Double] = []
        lines.append(maxData)
        for index in 1...4 {
            let progress = maxData / 4
            lines.insert(maxData - (progress * Double(index)), at: 0)
        }
        return lines
    }
    
    func getBarWidth(point: Double, size: CGSize) -> Double {
        (point / maxData) * (size.width - 74)
    }
    
    func showOver50(index: Int) -> Bool {
        if datas[index] >= 50 {
            return true
        }
        return false
    }
}
