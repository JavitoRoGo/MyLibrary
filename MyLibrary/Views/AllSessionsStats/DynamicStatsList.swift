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
		var date = Date()
		let firstSessionDate = model.user.sessions.first?.date ?? .now
		
		if graphSelected == 0 {
			date = firstSessionDate - 6.days
		} else if graphSelected == 1 {
			date = firstSessionDate - 29.days
		} else if graphSelected == 2 {
			date = firstSessionDate - 1.years
		} else if graphSelected == 3 {
			date = model.user.sessions.last?.date ?? .now
		}
		
        return date.formatted(date: .numeric, time: .omitted)
    }
    var toDate: String {
		let date = model.user.sessions.first?.date ?? .now
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
