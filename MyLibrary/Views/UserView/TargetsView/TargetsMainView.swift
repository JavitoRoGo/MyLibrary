//
//  TargetsMainView.swift
//  MyLibrary
//
//  Created by Javier Rodríguez Gómez on 12/1/23.
//

import SwiftUI

struct TargetsMainView: View {
    @Environment(GlobalViewModel.self) var model
	@EnvironmentObject var preferences: UserPreferences
    
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
                                Text("\(model.userLogic.readToday(dailyTarget).0) / \(model.userLogic.dailyTargetText(dailyTarget))")
                            }
                            Spacer()
							RingTargetView(color: .red, current: model.userLogic.readToday(dailyTarget).1, target: dailyTarget == .pages ? preferences.dailyPagesTarget : Int(preferences.dailyTimeTarget))
                                .frame(height: 50)
                        }
                    }
                    NavigationLink(destination: WeeklyTargetView(weeklyTarget: $weeklyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Semanal")
                                    .font(.title2.bold())
                                Text("\(model.userLogic.readThisWeek(weeklyTarget).0) / \(model.userLogic.weeklyTargetText(weeklyTarget))")
                            }
                            Spacer()
							RingTargetView(color: .orange, current: model.userLogic.readThisWeek(weeklyTarget).1, target: weeklyTarget == .pages ? preferences.weeklyPagesTarget : Int(preferences.weeklyTimeTarget))
                                .frame(height: 50)
                        }
                    }
                    NavigationLink(destination: MonthlyTargetView(monthlyTarget: $monthlyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Mensual")
                                    .font(.title2.bold())
                                Text("\(model.userLogic.readThisMonth(monthlyTarget).0) / \(model.userLogic.monthlyTargetText(monthlyTarget))")
                            }
                            Spacer()
							RingTargetView(color: .green, current: model.userLogic.readThisMonth(monthlyTarget).1, target: monthlyTarget == .books ? preferences.monthlyBooksTarget : preferences.monthlyPagesTarget)
                                .frame(height: 50)
                        }
                    }
                    NavigationLink(destination: YearlyTargetView(yearlyTarget: $yearlyTarget)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Anual")
                                    .font(.title2.bold())
                                Text("\(model.userLogic.readThisYear(yearlyTarget).0) / \(model.userLogic.yearlyTargetText(yearlyTarget))")
                            }
                            Spacer()
							RingTargetView(color: .blue, current: model.userLogic.readThisYear(yearlyTarget).1, target: yearlyTarget == .books ? preferences.yearlyBooksTarget : preferences.yearlyPagesTarget)
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
                        RollingText(color: .red, value: numOfAchivedDailyTarget)
                    }
                    HStack {
                        Text("Semanal")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .orange, value: numOfAchivedWeeklyTarget)
                    }
                    HStack {
                        Text("Mensual")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .green, value: numOfAchivedMonthlyTarget)
                    }
                    HStack {
                        Text("Anual")
                            .font(.title2.bold())
                        Spacer()
                        RollingText(color: .blue, value: numOfAchivedYearlyTarget)
                    }
                } footer: {
					Text("Número de veces que se ha conseguido cada objetivo desde el registro de la primera sesión: \((model.userLogic.user.sessions.last?.date ?? .now).toString).")
                }
            }
            .navigationTitle("Objetivos")
            .navigationBarTitleDisplayMode(.inline)
			.onAppear {
				numOfAchivedDailyTarget = 0
				numOfAchivedWeeklyTarget = 0
				numOfAchivedMonthlyTarget = 0
				numOfAchivedYearlyTarget = 0
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
					withAnimation(.linear(duration: 1.2)) {
						numOfAchivedDailyTarget = model.userLogic.numOfAchivedDailyTarget(dailyTarget)
						numOfAchivedWeeklyTarget = model.userLogic.numOfAchivedWeeklyTarget(weeklyTarget)
						numOfAchivedMonthlyTarget = model.userLogic.numOfAchivedMonthlyTarget(monthlyTarget)
						numOfAchivedYearlyTarget = model.userLogic.numOfAchivedYearlyTarget(yearlyTarget)
					}
				}
			}
        }
    }
}

struct TargetsMainView_Previews: PreviewProvider {
    static var previews: some View {
        TargetsMainView()
			.environment(GlobalViewModel.preview)
			.environmentObject(UserPreferences())
    }
}
