//
//  TargetsMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/1/23.
//

import SwiftUI

struct TargetsMainView: View {
    @EnvironmentObject var model: UserViewModel
    
    @State private var dailyTarget: DWTarget = .pages
    @State private var weeklyTarget: DWTarget = .pages
    @State private var monthlyTarget: MYTarget = .books
    @State private var yearlyTarget: MYTarget = .books
    
    @State private var numOfAchivedDailyTarget = 0
    @State private var numOfAchivedWeeklyTarget = 0
    @State private var numOfAchivedMonthlyTarget = 0
    @State private var numOfAchivedYearlyTarget = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: DailyTargetView(dailyTarget: $dailyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Diario")
                                    .font(.title2.bold())
                                Text("\(model.readToday(dailyTarget).0) / \(model.dailyTargetText(dailyTarget))")
                            }
                            Spacer()
                            RingTargetView(color: .red, current: model.readToday(dailyTarget).1, target: dailyTarget == .pages ? model.dailyPagesTarget : Int(model.dailyTimeTarget))
                                .frame(height: 50)
                        }
                    }
                    NavigationLink(destination: WeeklyTargetView(weeklyTarget: $weeklyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Semanal")
                                    .font(.title2.bold())
                                Text("\(model.readThisWeek(weeklyTarget).0) / \(model.weeklyTargetText(weeklyTarget))")
                            }
                            Spacer()
                            RingTargetView(color: .orange, current: model.readThisWeek(weeklyTarget).1, target: weeklyTarget == .pages ? model.weeklyPagesTarget : Int(model.weeklyTimeTarget))
                                .frame(height: 50)
                        }
                    }
                    NavigationLink(destination: MonthlyTargetView(monthlyTarget: $monthlyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Mensual")
                                    .font(.title2.bold())
                                Text("\(model.readThisMonth(monthlyTarget).0) / \(model.monthlyTargetText(monthlyTarget))")
                            }
                            Spacer()
                            RingTargetView(color: .green, current: model.readThisMonth(monthlyTarget).1, target: monthlyTarget == .books ? model.monthlyBooksTarget : model.monthlyPagesTarget)
                                .frame(height: 50)
                        }
                    }
                    NavigationLink(destination: YearlyTargetView(yearlyTarget: $yearlyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Anual")
                                    .font(.title2.bold())
                                Text("\(model.readThisYear(yearlyTarget).0) / \(model.yearlyTargetText(yearlyTarget))")
                            }
                            Spacer()
                            RingTargetView(color: .blue, current: model.readThisYear(yearlyTarget).1, target: yearlyTarget == .books ? model.yearlyBooksTarget : model.yearlyPagesTarget)
                                .frame(height: 50)
                        }
                    }
                } footer: {
                    Text("Pulsa sobre cada línea para fijar el valor de tus objetivos.")
                }
                Section {
                    HStack {
                        Text("Diario")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .red, value: $numOfAchivedDailyTarget)
                    }
                    HStack {
                        Text("Semanal")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .orange, value: $numOfAchivedWeeklyTarget)
                    }
                    HStack {
                        Text("Mensual")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .green, value: $numOfAchivedMonthlyTarget)
                    }
                    HStack {
                        Text("Anual")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .blue, value: $numOfAchivedYearlyTarget)
                    }
                } footer: {
                    Text("Número de veces que se ha conseguido cada objetivo desde el registro de la primera sesión: \(dateToString(model.user.sessions.last?.date ?? .now)).")
                }
            }
            .navigationTitle("Objetivos")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                numOfAchivedDailyTarget = model.numOfAchivedDailyTarget(dailyTarget)
                numOfAchivedWeeklyTarget = model.numOfAchivedWeeklyTarget(weeklyTarget)
                numOfAchivedMonthlyTarget = model.numOfAchivedMonthlyTarget(monthlyTarget)
                numOfAchivedYearlyTarget = model.numOfAchivedYearlyTarget(yearlyTarget)
            }
        }
    }
}

struct TargetsMainView_Previews: PreviewProvider {
    static var previews: some View {
        TargetsMainView()
            .environmentObject(UserViewModel())
    }
}
