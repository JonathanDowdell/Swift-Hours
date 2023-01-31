//
//  EntriesViewModel.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/25/23.
//

import SwiftUI
import Combine

extension EntriesView {
    class ViewModel: ObservableObject {
        
        @Published var yearWorkEntityDictionary: [Int: [Int: [Int: [Int: [WorkEntity]]]]] = [:]
        
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
                self.workEntryByJob = self.workEntriesGroupedByJob(self.yearWorkEntityDictionary)
                self.workEntryByMonth = self.groupMonthWorkEntries(self.yearWorkEntityDictionary)
                self.workEntryByWeek = self.groupWeekWorkEntries(self.yearWorkEntityDictionary)
            }
            .store(in: &cancellableSet)
        }
        
        deinit {
            for set in cancellableSet {
                set.cancel()
            }
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
                let week = calendar.component(.weekOfYear, from: workEntity.safeStart)
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
