//
//  RDGlobalStatsExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 10/8/23.
//

import SwiftUI

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
				  paper: model.calcRDDurationPerFormatt(.paper).total.minPerDayDoubleToString,
				  kindle: model.calcRDDurationPerFormatt(.kindle).total.minPerDayDoubleToString,
				  total: model.calcRDDurationPerFormatt().total.minPerDayDoubleToString),
            .init(title: "Tiempo promedio:",
				  paper: model.calcRDDurationPerFormatt(.paper).mean.minPerDayDoubleToString,
				  kindle: model.calcRDDurationPerFormatt(.kindle).mean.minPerDayDoubleToString,
				  total: model.calcRDDurationPerFormatt().mean.minPerDayDoubleToString),
            .init(title: "Velocidad promedio:",
				  paper: model.calcRDMinPerPagPerFormatt(.paper).minPerPagDoubleToString,
				  kindle: model.calcRDMinPerPagPerFormatt(.kindle).minPerPagDoubleToString,
				  total: model.meanMinPerPag.minPerPagDoubleToString),
            .init(title: "Dedicación promedio:",
				  paper: model.calcRDMinPerDayPerFormatt(.paper).minPerDayDoubleToString,
				  kindle: model.calcRDMinPerDayPerFormatt(.kindle).minPerDayDoubleToString,
				  total: model.meanMinPerDay.minPerDayDoubleToString),
            .init(title: "pág/día promedio:",
                  paper: String(model.calcRDPagPerDayPerFormatt(.paper)),
                  kindle: String(model.calcRDPagPerDayPerFormatt(.kindle)),
                  total: String(Int(model.meanPagPerDay))),
            .init(title: "Valoración promedio:",
				  paper: "\(model.meanRDRatingPerFormatt(.paper), format: .number.precision(.fractionLength(1)))",
                  kindle: "\(model.meanRDRatingPerFormatt(.kindle), format: .number.precision(.fractionLength(1)))",
                  total: "\(model.meanRDRatingPerFormatt(), format: .number.precision(.fractionLength(1)))")
        ]
    }
}
