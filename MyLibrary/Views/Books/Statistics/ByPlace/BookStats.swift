//
//  BookStats.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 5/1/22.
//

// Se mantiene la gráfica inicial y sus estadísticas por ubicación como ejemplo de gráfica pre-SwiftCharts

import SwiftUI

struct BookStats: View {
    @EnvironmentObject var model: UserViewModel
    @EnvironmentObject var bmodel: BooksModel
    @State var place: String
    @State private var showingPlacePicker = false
    @State private var showingGraph = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Pulsa para elegir una ubicación")
                        .font(.footnote)
                    ZStack {
                        Button {
                            withAnimation {
                                showingPlacePicker = true
                            }
                        } label: {
                            Text(place == "all" ? "Todos" : place)
                                .font(.largeTitle)
                                .foregroundColor(.primary)
                                .frame(width: 200, height: 55)
                                .background(.tertiary)
                                .cornerRadius(20)
                                .shadow(color: .black, radius: 7)
                        }
                        .zIndex(1)
                        if showingPlacePicker {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button("Listo") {
                                        withAnimation {
                                            showingPlacePicker = false
                                        }
                                    }
                                    .padding()
                                }
                                Picker("Ubicación", selection: $place) {
                                    ForEach(model.myPlaces, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                            .background(Color(UIColor.systemGray2))
                            .opacity(1)
                            .zIndex(2)
                            .transition(.opacity)
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Libros:")
                            .font(.title3)
                        Spacer()
                        Text(String(bmodel.numAtPlace(place)))
                            .font(.largeTitle)
                            .frame(width: 75, height: 55)
                            .background(bmodel.numColor(bmodel.numAtPlace(place)))
                            .cornerRadius(15)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 2)
                            }
                            .shadow(color: .black, radius: 5)
                        Spacer()
                    }
                    .padding(.top, 30)
                }
                .padding(.top, 10)
                
                List {
                    Section("Número de páginas: \(noDecimalFormatter.string(from: NSNumber(value: bmodel.globalPages().total))!)") {
                        let value = bmodel.pagesAtPlace(place).total
                        let mean = bmodel.pagesAtPlace(place).mean
                        let globalMean = bmodel.globalPages().mean
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
                    Section("Precio: \(priceFormatter.string(from: NSNumber(value: bmodel.globalPrice().total))!)") {
                        let value = bmodel.priceAtPlace(place).total
                        let mean = bmodel.priceAtPlace(place).mean
                        let globalMean = bmodel.globalPrice().mean
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
                    Section("Grosor (cm): \(measureFormatter.string(from: NSNumber(value: bmodel.globalThickness().total))!)") {
                        let value = bmodel.thicknessAtPlace(place).total
                        let mean = bmodel.thicknessAtPlace(place).mean
                        let globalMean = bmodel.globalThickness().mean
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
                    Section("Peso (g): \(noDecimalFormatter.string(from: NSNumber(value: bmodel.globalWeight().total))!)") {
                        let value = bmodel.weightAtPlace(place).total
                        let mean = bmodel.weightAtPlace(place).mean
                        let globalMean = bmodel.globalWeight().mean
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
            
            if showingGraph {
                GraphView()
            }
        }
        .navigationTitle("Datos por ubicación")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingGraph.toggle()
                } label: {
                    Image(systemName: "chart.xyaxis.line")
                }
            }
        }
    }
}

struct BookStats_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BookStats(place: "A1")
                .environmentObject(UserViewModel())
                .environmentObject(BooksModel())
        }
    }
}
