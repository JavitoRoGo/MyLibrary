//
//  OtherStats.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/10/22.
//

import SwiftUI

struct OtherStats: View {
    @EnvironmentObject var model: BooksModel
    
    let titles = ["Autor", "Editorial", "Encuadernación", "Propietario", "Estado"]
    @State private var statsSelection = 0
    @State private var pickerSelection = "Elige un valor"
    
    @State private var showingPicker = false
    @State private var showingGraphs = false
    
    var body: some View {
        ZStack {
            VStack {
                Picker("Categoría", selection: $statsSelection) {
                    ForEach(titles.indices, id:\.self) { index in
                        Text(titles[index])
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                VStack {
                    Text("Pulsa para elegir un valor")
                        .font(.footnote)
                    ZStack {
                        Button {
                            withAnimation {
                                showingPicker = true
                            }
                        } label: {
                            Text(pickerSelection)
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 400, height: 40)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                        if showingPicker {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button("Listo") {
                                        withAnimation {
                                            showingPicker = false
                                        }
                                    }
                                    .padding()
                                }
                                Picker("Valor", selection: $pickerSelection) {
                                    ForEach(model.arrayOfLabelsByCategoryForPickerAndGraph(tag: statsSelection), id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                            .background(Color(UIColor.systemGray2))
                            .opacity(1)
                            .transition(.opacity)
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Libros:")
                            .font(.title3)
                        Spacer()
                        Text(String(model.numOfBooksForOtherStats(tag: statsSelection, text: pickerSelection)))
                            .font(.largeTitle)
                            .frame(width: 75, height: 55)
                            .background(.orange)
                            .cornerRadius(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 2)
                            }
                            .shadow(color: .black, radius: 5)
                        Spacer()
                    }
                    .padding(.top, 30)
                }
                .padding(.top, 15)
                
                List {
                    Section("Número de páginas: \(model.globalPages().total)") {
                        let value = model.numOfPagesForOtherStats(tag: statsSelection, text: pickerSelection).total
                        let mean = model.numOfPagesForOtherStats(tag: statsSelection, text: pickerSelection).mean
                        let globalMean = model.globalPages().mean
                        let compare = compareWithMean(value: Double(mean), mean: Double(globalMean))
                        HStack {
                            VStack {
                                Text("Total:")
                                    .font(.subheadline)
                                Text(noDecimalFormatter.string(from: NSNumber(value: value))!)
                                    .font(.title2)
                            }
                            Spacer()
                            VStack {
                                Text("Promedio:")
                                    .font(.subheadline)
                                Text(String(mean))
                                    .font(.title2)
                                    .foregroundColor(compare.color)
                            }
                            Spacer()
                            VStack {
                                Text("Global:")
                                    .font(.subheadline)
                                Text(String(globalMean))
                                    .font(.title2)
                            }
                        }
                    }
                    Section("Precio: \(priceFormatter.string(from: NSNumber(value: model.globalPrice().total))!)") {
                        let value = model.priceForOtherStats(tag: statsSelection, text: pickerSelection).total
                        let mean = model.priceForOtherStats(tag: statsSelection, text: pickerSelection).mean
                        let globalMean = model.globalPrice().mean
                        let compare = compareWithMean(value: mean, mean: globalMean)
                        HStack {
                            VStack {
                                Text("Total:")
                                    .font(.subheadline)
                                Text(priceFormatter.string(from: NSNumber(value: value))!)
                                    .font(.title2)
                            }
                            Spacer()
                            VStack {
                                Text("Promedio:")
                                    .font(.subheadline)
                                Text(priceFormatter.string(from: NSNumber(value: mean))!)
                                    .font(.title2)
                                    .foregroundColor(compare.color)
                            }
                            Spacer()
                            VStack {
                                Text("Global:")
                                    .font(.subheadline)
                                Text(priceFormatter.string(from: NSNumber(value: globalMean))!)
                                    .font(.title2)
                            }
                        }
                    }
                    Section("Grosor (cm): \(measureFormatter.string(from: NSNumber(value: model.globalThickness().total))!)") {
                        let value = model.thicknessForOtherStats(tag: statsSelection, text: pickerSelection).total
                        let mean = model.thicknessForOtherStats(tag: statsSelection, text: pickerSelection).mean
                        let globalMean = model.globalThickness().mean
                        let compare = compareWithMean(value: mean, mean: globalMean)
                        HStack {
                            VStack {
                                Text("Total:")
                                    .font(.subheadline)
                                Text(measureFormatter.string(from: NSNumber(value: value))!)
                                    .font(.title2)
                            }
                            Spacer()
                            VStack {
                                Text("Promedio:")
                                    .font(.subheadline)
                                Text(measureFormatter.string(from: NSNumber(value: mean))!)
                                    .font(.title2)
                                    .foregroundColor(compare.color)
                            }
                            Spacer()
                            VStack {
                                Text("Global:")
                                    .font(.subheadline)
                                Text(measureFormatter.string(from: NSNumber(value: globalMean))!)
                                    .font(.title2)
                            }
                        }
                    }
                    Section("Peso (g): \(model.globalWeight().total)") {
                        let value = model.weightForOtherStats(tag: statsSelection, text: pickerSelection).total
                        let mean = model.weightForOtherStats(tag: statsSelection, text: pickerSelection).mean
                        let globalMean = model.globalWeight().mean
                        let compare = compareWithMean(value: Double(mean), mean: Double(globalMean))
                        HStack {
                            VStack {
                                Text("Total:")
                                    .font(.subheadline)
                                Text(noDecimalFormatter.string(from: NSNumber(value: value))!)
                                    .font(.title2)
                            }
                            Spacer()
                            VStack {
                                Text("Promedio:")
                                    .font(.subheadline)
                                Text(noDecimalFormatter.string(from: NSNumber(value: mean))!)
                                    .font(.title2)
                                    .foregroundColor(compare.color)
                            }
                            Spacer()
                            VStack {
                                Text("Global:")
                                    .font(.subheadline)
                                Text(noDecimalFormatter.string(from: NSNumber(value: globalMean))!)
                                    .font(.title2)
                            }
                        }
                    }
                }
            }
            
            if showingGraphs {
                OtherGraphs()
            }
        }
        .navigationTitle("Estadísticas")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingGraphs.toggle()
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
        }
    }
}

struct OtherStats_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OtherStats()
                .environmentObject(BooksModel())
        }
    }
}
