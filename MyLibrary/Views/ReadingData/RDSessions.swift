//
//  RDSessions.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 1/3/22.
//

import SwiftUI

struct RDSessions: View {
    @EnvironmentObject var model: GlobalViewModel
    
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
            Section(rdata?.bookTitle ?? "") {
                ForEach(rdsessions) { session in
                    RSRow(session: session)
                }
            }
        }
        .navigationTitle("Sesiones de lectura")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink(destination: RSBarGraph(datas: graphDatas, labels: graphLabels)) {
                Image(systemName: "chart.bar")
            }
        }
    }
}

struct RDSessions_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RDSessions(rdsessions: ReadingData.dataTest.readingSessions, rdata: ReadingData.dataTest)
				.environmentObject(GlobalViewModel.preview)
        }
    }
}
