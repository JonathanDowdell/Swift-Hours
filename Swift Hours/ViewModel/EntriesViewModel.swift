//
//  EntriesViewModel.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/25/23.
//

import SwiftUI
import Combine

extension EntriesView {
    struct WeekOfYear: Hashable {
        let year: Int
        let week: Int
    }
    
    class ViewModel: ObservableObject {
        
        @Published var yearWorkEntityDictionary: [Int: [Int: [Int: [Int: [WorkEntity]]]]] = [:]
        
        @Published var workEntryByDay: [Date: [WorkEntry]] = [:]
        
        @Published var workEntryByJob: [WorkEntry] = []
        
        @Published var workEntryByMonth: [MonthWorkEntry] = []
        
        @Published var workEntryByWeek: [WeekWorkEntry] = []
        
        @Published var searchText = ""
        
        @Published var showGrouping = false
        
        private var cancellableSet = Set<AnyCancellable>()
        
        init(
            workPublisher: AnyPublisher<[WorkEntity], Never> = WorkStorage.shared.work.eraseToAnyPublisher()
        ) {
            workPublisher.sink { [weak self] work in
                guard let self = self else { return }
                self.yearWorkEntityDictionary = self.aggregateWorkToYearly(work)
                self.workEntryByDay = self.groupWorkByDayOfYear(work)
                self.workEntryByJob = self.workEntriesGroupedByJob(self.yearWorkEntityDictionary)
                self.workEntryByMonth = self.groupMonthWorkEntries(self.yearWorkEntityDictionary)
                self.workEntryByWeek = self.groupWorkByWeekOfYear(work)
            }
            .store(in: &cancellableSet)
        }
        
        deinit {
            for set in cancellableSet {
                set.cancel()
            }
        }
        
        func groupWorkByDayOfYear(_ workList: [WorkEntity]) -> [Date: [WorkEntry]] {
            let calendar = Calendar.current
            var workEntitiesGroup = [Date: [WorkEntity]]()
            var workEntriesGroup = [Date: [WorkEntry]]()
            
            for work in workList {
                let key = calendar.startOfDay(for: work.safeStart)
                
                if workEntitiesGroup[key] == nil {
                    workEntitiesGroup[key] = [WorkEntity]()
                }
                
                workEntitiesGroup[key]?.append(work)
            }
            
            for key in workEntitiesGroup.keys.sorted() {
                if let workEntities = workEntitiesGroup[key] {
                    let groupedByJob = Dictionary(grouping: workEntities, by: { $0.job })
                    let workEntries = groupedByJob.map { WorkEntry(job: $0.key!, work: $0.value) }
                    workEntriesGroup[key] = workEntries
                }
            }
            
            return workEntriesGroup
            
//            let calendar = Calendar.current
//            var workGroupedByDayOfYear: [Int: [Int: [WorkEntity]]] = [:]
//            var wkEntries = [Int: [WorkEntry]]()
//
//            for work in workList {
//                let date = work.safeStart
//                let day = calendar.component(.day, from: date)
//                let year = calendar.component(.year, from: date)
//
//                if workGroupedByDayOfYear[year] == nil {
//                    workGroupedByDayOfYear[year] = [day: [work]]
//                } else if workGroupedByDayOfYear[year]![day] == nil {
//                    workGroupedByDayOfYear[year]![day] = [work]
//                } else {
//                    workGroupedByDayOfYear[year]![day]?.append(work)
//                }
//            }
//
//            let sortedYears = workGroupedByDayOfYear.keys.sorted()
//
//            for year in sortedYears {
//                let sortedDays = workGroupedByDayOfYear[year]!.keys.sorted()
//
//                for day in sortedDays {
//                    let workForDay = workGroupedByDayOfYear[year]![day]!
//                    let workGroupedByJob = Dictionary(grouping: workForDay, by: { $0.job })
//                    let workEntriesForDay = workGroupedByJob.map { WorkEntry(job: $0.key!, work: $0.value) }
//                    wkEntries[day] = workEntriesForDay
//                }
//            }
//            return wkEntries
        }
        
        func groupWorkByWeekOfYear(_ workList: [WorkEntity]) -> [WeekWorkEntry] {
            var workGroupedByWeekOfYear = [WeekOfYear: [WorkEntity]]()
            var weekEntries = [WeekWorkEntry]()
            let calendar = Calendar.current
            for work in workList {
                let workDate = work.safeStart
                let year = calendar.component(.year, from: workDate)
                let weekOfYear = calendar.component(.weekOfYear, from: workDate)
                let key = WeekOfYear(year: year, week: weekOfYear)
                if workGroupedByWeekOfYear[key] == nil {
                    workGroupedByWeekOfYear[key] = [WorkEntity]()
                }
                workGroupedByWeekOfYear[key]!.append(work)
            }
            
            let keys = workGroupedByWeekOfYear.keys.sorted(by: { $0.year < $1.year })
            for key in keys {
                if let workEntities = workGroupedByWeekOfYear[key], let date = workEntities.first?.safeStart {
                    weekEntries.append(WeekWorkEntry(date: date, workEntry: groupWorkEntriesByWeek(workEntities)))
                }
            }
            return weekEntries
        }
        
        func groupWeekWorkEntries(_ data: [Int: [Int: [Int: [Int: [WorkEntity]]]]]) -> [WeekWorkEntry] {
            var weekEntries = [WeekWorkEntry]()
            for key in yearWorkEntityDictionary.keys {
                if let yearsDictionary = yearWorkEntityDictionary[key] {
                    for monthKey in yearsDictionary.keys {
                        let monthValue = yearsDictionary[monthKey]
                        if let monthValue = monthValue {
                            for weekKey in monthValue.keys {
                                let week = monthValue[weekKey]
                                if let value = week.flatMap({ $0.values.flatMap { $0 } }), let date = value.first?.safeStart {
                                    weekEntries.append(WeekWorkEntry(date: date, workEntry: groupWorkEntriesByWeek(value)))
                                }
                            }
                        }
                    }
                }
            }
            return weekEntries
        }
        
        func groupWorkEntriesByWeek(_ workEntities: [WorkEntity]) -> [WorkEntry] {
            var workEntries = [WorkEntry]()
            let workGroupedByJob = Dictionary(grouping: workEntities, by: { $0.job })
            for (key, workEntities) in workGroupedByJob {
                if let job = key {
                    workEntries.append(WorkEntry(job: job, work: workEntities))
                }
            }
            return workEntries
        }
        
        ///===========================================================================>
        
        func groupMonthWorkEntries(_ data: [Int: [Int: [Int: [Int: [WorkEntity]]]]]) -> [MonthWorkEntry] {
            var monthWorkEntriesList = [MonthWorkEntry]()
            let yearWorkEntityDictionary = data
            for key in yearWorkEntityDictionary.keys {
                if let value = yearWorkEntityDictionary[key] {
                    for monthKey in value.keys {
                        let monthValue = value[monthKey]
                        if let monthDate = monthValue?.values.first?.values.first?.first?.safeStart, let monthValue = monthValue {
                            let monthWorkEntry = MonthWorkEntry(date: monthDate, workEntry: groupWorkEntriesByJob(monthValue))
                            monthWorkEntriesList.append(monthWorkEntry)
                        }
                    }
                }
            }
            return monthWorkEntriesList
        }
        
        func groupWorkEntriesByJob(_ data: [Int: [Int: [WorkEntity]]]) -> [WorkEntry] {
            var workEntries = [WorkEntry]()
            let data = data.values.flatMap { $0.values.flatMap { $0 } }
            let dataGroupedByJob = Dictionary(grouping: data, by: { $0.job })
            for (key, value) in dataGroupedByJob {
                if let key = key {
                    let we = WorkEntry(job: key, work: value)
                    workEntries.append(we)
                }
            }
            return workEntries
        }
        
        ///===========================================================================>
        
        func workEntriesGroupedByJob(_ data: [Int: [Int: [Int: [Int: [WorkEntity]]]]]) -> [WorkEntry] {
            let data = data.values.flatMap { $0.values.flatMap { $0.values.flatMap { $0.flatMap { $0.value.compactMap { $0 } } } } }
            let valuesGrouping = Dictionary(grouping: data, by: { $0.job })
            var workEntries = [WorkEntry]()
            for (job, work) in valuesGrouping {
                if let job = job {
                    workEntries.append(WorkEntry(job: job, work: work))
                }
            }
            return workEntries.sorted { $0.job.name ?? "A" > $1.job.name ?? "B" }
        }
        
        func getYearlyData(_ data: [Int: [Int: [Int: [WorkEntity]]]]) -> [WorkEntry] {
            let values = data.values.flatMap { $0.values.flatMap { $0.values.flatMap { $0 } } }
            let valuesGrouping = Dictionary(grouping: values, by: { $0.job })
            var workEntries = [WorkEntry]()
            for (job, work) in valuesGrouping {
                if let job = job {
                    workEntries.append(WorkEntry(job: job, work: work))
                }
            }
            return workEntries
        }
        
        private func aggregateWorkToMonthly(_ yearWorkEntityDictionary: [Int: [Int: [Int: [Int: [WorkEntity]]]]]) -> [[Int: [Int: [Int: [WorkEntity]]]]] {
            var values: [Int: [Int: [Int: [WorkEntity]]]] = [:]
            for key in yearWorkEntityDictionary.keys {
                let value = values[key] ?? .init()
                values[key] = value
            }
            
            
//            var monthWorkEntityDictionary: [[Int: [Int: [Int: [WorkEntity]]]]] = []
//            let values = yearWorkEntityDictionary.values.map { $0 }
//            monthWorkEntityDictionary.append(contentsOf: values)
//            return monthWorkEntityDictionary
            return .init()
        }
        
        private func aggregateWorkToYearly(_ workEntities: [WorkEntity]) -> [Int: [Int: [Int: [Int: [WorkEntity]]]]] {
            let calendar = Calendar.current
            
            var workEntitiesDictionary: [Int: [Int: [Int: [Int: [WorkEntity]]]]] = [:]
            for workEntity in workEntities {
                let year = calendar.component(.year, from: workEntity.safeStart)
                let month = calendar.component(.month, from: workEntity.safeStart)
                let week = calendar.component(.weekOfMonth, from: workEntity.safeStart)
                let day = calendar.component(.weekday, from: workEntity.safeStart)
                
                if workEntitiesDictionary[year] == nil {
                    workEntitiesDictionary[year] = [:]
                }
                
                if workEntitiesDictionary[year]?[month] == nil {
                    workEntitiesDictionary[year]?[month] = [:]
                }
                
                if workEntitiesDictionary[year]?[month]?[week] == nil {
                    workEntitiesDictionary[year]?[month]?[week] = [:]
                }
                
                if workEntitiesDictionary[year]?[month]?[week]?[day] == nil {
                    workEntitiesDictionary[year]?[month]?[week]?[day] = []
                }
                
                workEntitiesDictionary[year]?[month]?[week]?[day]?.append(workEntity)
            }
            
            return workEntitiesDictionary
        }
    }
}
