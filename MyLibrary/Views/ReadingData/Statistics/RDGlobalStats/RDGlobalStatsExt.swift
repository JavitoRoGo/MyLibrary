//
//  RDGlobalStatsExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/8/23.
//

import Foundation

extension RDGlobalStats {
    func loadData() {
        datas = [
            .init(title: "Registros:",
                  paper: String(model.numberOfReadingDataPerFormatt(.paper)),
                  kindle: String(model.numberOfReadingDataPerFormatt(.kindle)),
				  total: String(model.user.readingDatas.count)),
            .init(title: "Páginas:",
                  paper: noDecimalFormatter.string(from: NSNumber(value: model.calcRDPagesPerFormatt(.paper).total))!,
                  kindle: noDecimalFormatter.string(from: NSNumber(value: model.calcRDPagesPerFormatt(.kindle).total))!,
                  total: noDecimalFormatter.string(from: NSNumber(value: model.calcRDPagesPerFormatt().total))!),
            .init(title: "Páginas promedio:",
                  paper: String(model.calcRDPagesPerFormatt(.paper).mean),
                  kindle: String(model.calcRDPagesPerFormatt(.kindle).mean),
                  total: String(model.calcRDPagesPerFormatt().mean)),
            .init(title: "Tiempo:",
                  paper: minPerDayDoubleToString(model.calcRDDurationPerFormatt(.paper).total),
                  kindle: minPerDayDoubleToString(model.calcRDDurationPerFormatt(.kindle).total),
                  total: minPerDayDoubleToString(model.calcRDDurationPerFormatt().total)),
            .init(title: "Tiempo promedio:",
                  paper: minPerDayDoubleToString(model.calcRDDurationPerFormatt(.paper).mean),
                  kindle: minPerDayDoubleToString(model.calcRDDurationPerFormatt(.kindle).mean),
                  total: minPerDayDoubleToString(model.calcRDDurationPerFormatt().mean)),
            .init(title: "Velocidad promedio:",
                  paper: minPerPagDoubleToString(model.calcRDMinPerPagPerFormatt(.paper)),
                  kindle: minPerPagDoubleToString(model.calcRDMinPerPagPerFormatt(.kindle)),
                  total: minPerPagDoubleToString(model.meanMinPerPag)),
            .init(title: "Dedicación promedio:",
                  paper: minPerDayDoubleToString(model.calcRDMinPerDayPerFormatt(.paper)),
                  kindle: minPerDayDoubleToString(model.calcRDMinPerDayPerFormatt(.kindle)),
                  total: minPerDayDoubleToString(model.meanMinPerDay)),
            .init(title: "pág/día promedio:",
                  paper: String(model.calcRDPagPerDayPerFormatt(.paper)),
                  kindle: String(model.calcRDPagPerDayPerFormatt(.kindle)),
                  total: String(Int(model.meanPagPerDay))),
            .init(title: "Valoración promedio:",
                  paper: measureFormatter.string(from: NSNumber(value: model.meanRDRatingPerFormatt(.paper)))!,
                  kindle: measureFormatter.string(from: NSNumber(value: model.meanRDRatingPerFormatt(.kindle)))!,
                  total: measureFormatter.string(from: NSNumber(value: model.meanRDRatingPerFormatt()))!)
        ]
    }
}
