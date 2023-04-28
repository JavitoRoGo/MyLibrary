//
//  LineChart.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 21/4/22.
//

import Charts
import SwiftUI

struct LineChart: View {
    @State private var pickerSelection = 0
    let titles = ["SwiftCharts", "Clásica"]
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Selección de gráfico", selection: $pickerSelection.animation(.easeInOut)) {
                    ForEach(titles.indices, id:\.self) { index in
                        Text(titles[index])
                    }
                }
                .pickerStyle(.segmented)
                
                if pickerSelection == 0 {
                    NewLineGraph()
                } else if pickerSelection == 1 {
                    OldLineChart()
                }
            }
            .padding()
            Spacer()
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 25)
                .fill(.ultraThinMaterial)
        }
        .navigationTitle("pág/día")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        LineChart()
            .environmentObject(RDModel())
    }
}


struct NewLineGraph: View {
    @EnvironmentObject var model: RDModel
    @State private var datasForLineChart: [DataForLineChart] = []
    
    var body: some View {
        Chart(datasForLineChart, id: \.name) { serie in
            ForEach(0..<serie.value.count, id: \.self) { index in
                LineMark(
                    x: .value("Libro", index),
                    y: .value("Valor", serie.animate[index] ? serie.value[index] : 0)
                )
                .interpolationMethod(.catmullRom)
            }
            .foregroundStyle(by: .value("Tipo", serie.name))
            
            RuleMark(y: .value("media", model.meanPagPerDay))
                .foregroundStyle(.black).lineStyle(.init(lineWidth: 3))
                .annotation(alignment: .leading) {
                    Text("media: \(model.meanPagPerDay, format: .number.precision(.fractionLength(0)))")
                        .font(.caption)
                    
                }
        }
        .chartXAxis(.hidden)
        .chartForegroundStyleScale(["pág/d": .blue.opacity(0.4), "Evolución": .red.opacity(0.4)])
        .task {
            datasForLineChart = [
                .init(name: "pág/d", value: model.datas().0, animate: .init(repeating: false, count: model.datas().0.count)),
                .init(name: "Evolución", value: model.datas().1, animate: .init(repeating: false, count: model.datas().1.count))
            ]
            animateGraph()
        }
    }
    
    func animateGraph() {
        for (index, serie) in datasForLineChart.enumerated() {
            for (subindex, _) in serie.animate.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(subindex) * 0.01) {
                    withAnimation(.easeInOut(duration: 0.8)) {
                        datasForLineChart[index].animate[subindex] = true
                    }
                }
            }
        }
    }
}

struct OldLineChart: View {
    @EnvironmentObject var model: RDModel
    var datas: ([Double], [Double]) {
        model.datas()
    }
    var maxY: Double {
        datas.0.max() ?? 0
    }
    var minY: Double {
        //        datas.0.min() ?? 0
        0
    }
    
    @State private var percentage: CGFloat = 0
    
    var body: some View {
        ZStack {
            VStack(spacing: 140) {
                ForEach(getGraphLines(), id: \.self) { line in
                    HStack(spacing: 8) {
                        Text(Int(line), format: .number)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(height: 20)
                        Rectangle()
                            .fill(.gray.opacity(0.2))
                            .frame(height: 1)
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: -10)
                }
            }
            
            ZStack {
                chartView(datas: datas.0)
                    .foregroundColor(.blue)
                chartView(datas: datas.1)
                    .foregroundColor(.red)
                chartView(datas: Array(repeating: model.meanPagPerDay, count: datas.0.count))
                    .foregroundColor(.primary)
            }
            .padding(.leading, 30)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
    
    func getGraphLines() -> [Double] {
        let max = getMax()
        var lines: [Double] = []
        lines.append(max)
        
        for index in 1...4 {
            let progress = max / 4
            lines.append(max - (progress * Double(index)))
        }
        return lines
    }
    
    func getMax() -> Double {
        let max = datas.0.max() ?? 0
        return max
    }
}

extension OldLineChart {
    @ViewBuilder
    func chartView(datas: [Double]) -> some View {
        GeometryReader { geometry in
            Path { path in
                for index in datas.indices {
                    let xPosition = geometry.size.width / CGFloat(datas.count) * CGFloat(index + 1)
                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((datas[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: .gray, radius: 10, x: 0, y: 10)
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: .gray.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartXLabels: some View {
        HStack {
            Text("Lo")
            Spacer()
            Text("Hi")
        }
        .font(.caption)
        .foregroundColor(.secondary)
    }
}
