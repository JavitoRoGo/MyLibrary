//
//  DynamicStatsList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 8/6/22.
//

import SwiftUI

struct DynamicStatsList: View {
    @EnvironmentObject var model: UserViewModel
    let graphSelected: Int
    
	var numberOfSessions: String {
		if graphSelected == 3 {
			return "\(model.user.sessions.count) sesiones"
		} else {
			return "\(model.getSessions(tag: graphSelected).count) sesiones"
		}
	}
    
    var fromDate: String {
        let date = model.getFromDate(tag: graphSelected)
        return date.formatted(date: .numeric, time: .omitted)
    }
    var toDate: String {
        let date = model.toDate
        return date.formatted(date: .numeric, time: .omitted)
    }
    
    var body: some View {
        List {
            Section(numberOfSessions) {
                NavigationLink(destination: RDSessions(rdsessions: Array(model.getSessions(tag: graphSelected)), rdata: nil)) {
                    Text(fromDate + " - " + toDate)
                }
                HStack {
                    Text("Tiempo de lectura")
                    Spacer()
                    Text(model.getReadingTime(tag: graphSelected))
                }
                HStack {
                    Text("Páginas leídas")
                    Spacer()
                    Text(model.graphData(tag: graphSelected).reduce(0, +), format: .number)
                }
            }
            Section {
                HStack {
                    Text("min/pág")
                    Spacer()
                    Text(model.getMinPerPag(tag: graphSelected))
                }
                HStack {
                    Text("min/día")
                    Spacer()
                    Text(model.getMinPerDay(tag: graphSelected))
                }
                HStack {
                    Text("pág/día")
                    Spacer()
                    Text(model.getPagPerDay(tag: graphSelected), format: .number.precision(.fractionLength(0)))
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct DynamicStatsList_Previews: PreviewProvider {
    static var previews: some View {
        DynamicStatsList(graphSelected: 0)
            .environmentObject(UserViewModel())
    }
}
