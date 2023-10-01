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
                  paper: String(model.userLogic.numberOfReadingDataPerFormatt(.paper)),
                  kindle: String(model.userLogic.numberOfReadingDataPerFormatt(.kindle)),
				  total: String(model.userLogic.user.readingDatas.count)),
            .init(title: "Páginas:",
				  paper: model.userLogic.calcRDPagesPerFormatt(.paper).total.formatted(.number),
				  kindle: model.userLogic.calcRDPagesPerFormatt(.kindle).total.formatted(.number),
				  total: model.userLogic.calcRDPagesPerFormatt().total.formatted(.number)),
            .init(title: "Páginas promedio:",
                  paper: String(model.userLogic.calcRDPagesPerFormatt(.paper).mean),
                  kindle: String(model.userLogic.calcRDPagesPerFormatt(.kindle).mean),
                  total: String(model.userLogic.calcRDPagesPerFormatt().mean)),
            .init(title: "Tiempo:",
				  paper: model.userLogic.calcRDDurationPerFormatt(.paper).total.minPerDayDoubleToString,
				  kindle: model.userLogic.calcRDDurationPerFormatt(.kindle).total.minPerDayDoubleToString,
				  total: model.userLogic.calcRDDurationPerFormatt().total.minPerDayDoubleToString),
            .init(title: "Tiempo promedio:",
				  paper: model.userLogic.calcRDDurationPerFormatt(.paper).mean.minPerDayDoubleToString,
				  kindle: model.userLogic.calcRDDurationPerFormatt(.kindle).mean.minPerDayDoubleToString,
				  total: model.userLogic.calcRDDurationPerFormatt().mean.minPerDayDoubleToString),
            .init(title: "Velocidad promedio:",
				  paper: model.userLogic.calcRDMinPerPagPerFormatt(.paper).minPerPagDoubleToString,
				  kindle: model.userLogic.calcRDMinPerPagPerFormatt(.kindle).minPerPagDoubleToString,
				  total: model.userLogic.meanMinPerPag.minPerPagDoubleToString),
            .init(title: "Dedicación promedio:",
				  paper: model.userLogic.calcRDMinPerDayPerFormatt(.paper).minPerDayDoubleToString,
				  kindle: model.userLogic.calcRDMinPerDayPerFormatt(.kindle).minPerDayDoubleToString,
				  total: model.userLogic.meanMinPerDay.minPerDayDoubleToString),
            .init(title: "pág/día promedio:",
                  paper: String(model.userLogic.calcRDPagPerDayPerFormatt(.paper)),
                  kindle: String(model.userLogic.calcRDPagPerDayPerFormatt(.kindle)),
                  total: String(Int(model.userLogic.meanPagPerDay))),
            .init(title: "Valoración promedio:",
				  paper: model.userLogic.meanRDRatingPerFormatt(.paper).formatted(.number.precision(.fractionLength(1))),
				  kindle: model.userLogic.meanRDRatingPerFormatt(.kindle).formatted(.number.precision(.fractionLength(1))),
				  total: model.userLogic.meanRDRatingPerFormatt().formatted(.number.precision(.fractionLength(1))))
        ]
    }
}
