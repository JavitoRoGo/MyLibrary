//
//  RDSessions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/3/22.
//

import SwiftUI

struct RDSessions: View {
    @Environment(GlobalViewModel.self) var model
    
    let rdsessions: [ReadingSession]
    let rdata: ReadingData?
    
    var graphDatas: [Double] {
        if let rdata = rdata {
			return model.userLogic.datasForSessionsBarGraph(book: rdata)
        }
		return model.userLogic.datas(sessions: rdsessions)
    }
    var graphLabels: [String] {
        if let rdata = rdata {
			return model.userLogic.getLabelsForSessionsBarGraph(book: rdata)
        }
		return model.userLogic.getXLabels(sessions: rdsessions)
    }
    
    var body: some View {
        List {
			if let rdata {
				Section(rdata.bookTitle) {
					ForEach(rdsessions) { session in
						RSRow(session: session)
					}
				}
			} else {
				if rdsessions.count > 370 {
					totalList
				} else if rdsessions.count > 50 {
					yearList
				} else {
					ForEach(rdsessions) { session in
						RSRow(session: session)
					}
				}
			}
        }
        .navigationTitle("Sesiones de lectura")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
			if rdsessions.count < 100 {
				NavigationLink(destination: RSBarGraph(datas: graphDatas, labels: graphLabels)) {
					Image(systemName: "chart.bar")
				}
			}
        }
    }
}

struct RDSessions_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RDSessions(rdsessions: ReadingData.dataTest.readingSessions, rdata: ReadingData.dataTest)
				.environment(GlobalViewModel.preview)
        }
    }
}
