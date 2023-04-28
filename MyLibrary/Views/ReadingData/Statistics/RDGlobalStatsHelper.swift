//
//  RDGlobalStatsHelper.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 23/12/22.
//

import SwiftUI

struct RDGlobalStatsData {
    let title: String
    let paper: String
    let kindle: String
    let total: String
}

struct RDGlobalStatsRow: View {
    let data: RDGlobalStatsData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(data.title).font(.footnote)
            HStack {
                Text(data.paper)
                    .foregroundColor(.green)
                Spacer()
                Text(data.kindle)
                    .foregroundColor(.orange)
                Spacer()
                Text(data.total)
            }
            .font(.title2.bold())
        }
    }
}
