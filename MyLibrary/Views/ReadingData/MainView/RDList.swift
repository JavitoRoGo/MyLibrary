//
//  RDList.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 3/1/22.
//

import SwiftUI

struct RDList: View {
    @Environment(GlobalViewModel.self) var model
    var year: Int? = nil
    
    var body: some View {
        List {
            if let year {
				Section("\(String(year)) - \(model.userLogic.numberOfReadingDataPerYear(year, filterBy: .all)) libros") {
					ForEach(model.userLogic.rdataPerYear(year, filterBy: .all)) { rdata in
                        NavigationLink(destination: RDDetail(rdata: rdata)) {
                            RDRow(rdata: rdata)
                        }
                    }
                }
            } else {
				ForEach(model.userLogic.user.bookFinishingYears.reversed(), id: \.self) { year in
					Section("\(String(year)) - \(model.userLogic.numberOfReadingDataPerYear(year, filterBy: .all)) libros") {
						ForEach(model.userLogic.rdataPerYear(year, filterBy: .all)) { rdata in
                            NavigationLink(destination: RDDetail(rdata: rdata)) {
                                RDRow(rdata: rdata)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Lecturas")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RDList_Previews: PreviewProvider {
    static var previews: some View {
        RDList()
			.environment(GlobalViewModel.preview)
    }
}
