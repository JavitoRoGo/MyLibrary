//
//  RDSessionsExt.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 14/12/23.
//

import Algorithms
import SwiftUI

extension RDSessions {
	var sessionsChunkedByMonth: [[ReadingSession]] {
		return rdsessions
			.sorted { $0.date > $1.date }
			.chunked { Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .month) }
			.map { Array($0) }
	}
	
	var yearList: some View {
		ForEach(sessionsChunkedByMonth, id: \.self) { sessions in
			DisclosureGroup {
				ForEach(sessions) { session in
					RSRow(session: session)
				}
			} label: {
				Text(sessions.first!.date.formatted(.dateTime.month(.wide)))
			}
		}
	}
	
	var sessionsChunkedByYearAndMonth: [[ReadingSession]] {
		return rdsessions
			.sorted { $0.date > $1.date }
			.chunked { Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .year) }
			.map { Array($0) }
	}
	
	var totalList: some View {
		ForEach(sessionsChunkedByYearAndMonth, id: \.self) { sessionsByYear in
			DisclosureGroup {
				let sessionsByMonth = sessionsByYear.chunked { Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .month) }.map { Array($0) }
				ForEach(sessionsByMonth, id: \.self) { sessions in
					DisclosureGroup {
						ForEach(sessions) { session in
							RSRow(session: session)
						}
					} label: {
						Text(sessions.first!.date.formatted(.dateTime.month(.wide)))
					}
				}
			} label: {
				Text(sessionsByYear.first!.date.formatted(.dateTime.year(.defaultDigits)))
			}
		}
	}
}
