//
//  RDDetail.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDDetail: View {
    @EnvironmentObject var model: RDModel
    
    @State var rdata: ReadingData
    @State var showingLocation = false
    @State var showingEditView = false
    @State var showingCommentsAlert = false
    
    var body: some View {
        VStack {
            RDScroll(rdata: $rdata)
            
            List {
                Section("Nº \(rdata.yearId) del año \(String(rdata.finishedInYear.rawValue))") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Título:")
                                .font(.subheadline)
                            Text(rdata.bookTitle)
                                .font(.headline)
                        }
                        Spacer()
                        if isThereAComment {
                            Button {
                                showingCommentsAlert = true
                            } label: {
                                Image(systemName: "quote.bubble")
                                    .font(.title3)
                                    .foregroundColor(.pink)
                            }
                        }
                    }
                }
                
                Section {
                    VStack(alignment: .leading) {
                        Text("Inicio - Fin:")
                            .font(.subheadline)
                        Text("\(dateToString(rdata.startDate)) - \(dateToString(rdata.finishDate))")
                            .font(.headline)
                    }
                    NavigationLink(destination: RDSessions(rdsessions: rdata.readingSessions, rdata: rdata)) {
                        HStack {
                            Text("Sesiones:")
                                .font(.subheadline)
                            Spacer()
                            Text(String(rdata.sessions))
                                .font(.headline)
                        }
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Tiempo:")
                                .font(.subheadline)
                            Text(rdata.duration)
                                .font(.headline)
                        }
                        Spacer()
                        VStack {
                            Text("Páginas:")
                                .font(.subheadline)
                            Text(String(rdata.pages))
                                .font(.headline)
                        }
                        Spacer()
                        VStack {
                            Text(">50 pág:")
                                .font(.subheadline)
                            Text(String(rdata.over50))
                                .font(.headline)
                        }
                    }
                }
                
                Section {
                    HStack {
                        let value = minPerPagInMinutes(rdata.minPerPag)
                        let mean = model.meanMinPerPag
                        let compare = compareWithMean(value: mean, mean: value)
                        
                        VStack {
                            Text("min/pág:")
                                .font(.subheadline)
                            Text(rdata.minPerPag)
                                .font(.headline)
                                .foregroundColor(compare.color)
                        }
                        Spacer()
                        VStack {
                            Text("Promedio:")
                                .font(.subheadline)
                            Text(minPerPagDoubleToString(mean))
                                .font(.headline)
                        }
                        Spacer()
                        Image(systemName: compare.image)
                            .foregroundColor(compare.color)
                            .font(.title)
                    }
                    HStack {
                        let value = minPerDayInHours(rdata.minPerDay)
                        let mean = model.meanMinPerDay
                        let compare = compareWithMean(value: value, mean: mean)
                        
                        VStack {
                            Text("min/día:")
                                .font(.subheadline)
                            Text(rdata.minPerDay)
                                .font(.headline)
                                .foregroundColor(compare.color)
                        }
                        Spacer()
                        VStack {
                            Text("Promedio:")
                                .font(.subheadline)
                            Text(minPerDayDoubleToString(mean))
                                .font(.headline)
                        }
                        Spacer()
                        Image(systemName: compare.image)
                            .foregroundColor(compare.color)
                            .font(.title)
                    }
                    HStack {
                        let value = rdata.pagPerDay
                        let mean = model.meanPagPerDay
                        let compare = compareWithMean(value: value, mean: mean)
                        
                        VStack {
                            Text("pág/día:")
                                .font(.subheadline)
                            Text(value, format: .number)
                                .font(.headline)
                                .foregroundColor(compare.color)
                        }
                        Spacer()
                        VStack {
                            Text("Promedio:")
                                .font(.subheadline)
                            Text(noDecimalFormatter.string(from: NSNumber(value: mean))!)
                                .font(.headline)
                        }
                        Spacer()
                        Image(systemName: compare.image)
                            .foregroundColor(compare.color)
                            .font(.title)
                    }
                    HStack {
                        let value = rdata.percentOver50
                        let mean = model.meanOver50
                        let compare = compareWithMean(value: value, mean: mean)
                        
                        VStack {
                            Text(">50 (%):")
                                .font(.subheadline)
                            Text(noDecimalFormatter.string(from: NSNumber(value: value))! + "%")
                                .font(.headline)
                                .foregroundColor(compare.color)
                        }
                        Spacer()
                        VStack {
                            Text("Promedio:")
                                .font(.subheadline)
                            Text(noDecimalFormatter.string(from: NSNumber(value: mean))! + "%")
                                .font(.headline)
                        }
                        Spacer()
                        Image(systemName: compare.image)
                            .foregroundColor(compare.color)
                            .font(.title)
                    }
                }
                
                Section {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Formato:")
                                .font(.subheadline)
                            Text(rdata.formatt.rawValue)
                                .font(.headline)
                        }
                        Spacer()
                        VStack {
                            Text("Valoración:")
                                .font(.subheadline)
                            RDStars(rating: .constant(rdata.rating))
                        }
                    }
                }
                
                Section {
                    Text(rdata.synopsis)
                }
            }
            .modifier(RDDetailModifier(rdata: $rdata, showingLocation: $showingLocation, showingEditView: $showingEditView, showingCommentsAlert: $showingCommentsAlert, isThereALocation: isThereALocation))
        }
    }
}

struct RDDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RDDetail(rdata: ReadingData.dataTest)
                .environmentObject(RDModel())
                .environmentObject(BooksModel())
        }
    }
}
