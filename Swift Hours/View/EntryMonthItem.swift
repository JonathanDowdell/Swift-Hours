//
//  EntryMonthItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/15/23.
//

import SwiftUI

struct Something: View {
    
    let groupedByWeek: [Date : [WorkEntity]]
    
    var body: some View {
        ForEach(groupedByWeek.keys.sorted(by: >), id: \.self) { key in
            let workEntityArray = groupedByWeek[key]
            if let workEntity = workEntityArray?.first {
                Section("Something") {
                    ForEach(getWorkEntriesGroupedByJob(workEntityArray: workEntityArray!), id: \.self) { workEntry in
                        EntryItem(workEntry: workEntry)
                    }
                }
            }
        }
    }
    
    private func getWorkEntriesGroupedByJob(workEntityArray: [WorkEntity]) -> [WorkEntry] {
        let grouping = Dictionary(grouping: workEntityArray) { $0.job! }
        let workEntries = grouping.map { WorkEntry(job: $0.key, work: $0.value) }
        return workEntries
    }
}

struct EntryMonthItem: View {
    
    @Binding var groupingBy: EntriesView.GroupingBy
    
    private(set) var monthWorkDictionary: [Int : [Int : [Int : [WorkEntity]]]]
    
    var workEntitiesFromAllMonths: [WorkEntity] {
        return monthWorkDictionary.flatMap { $0.value.flatMap { $0.value.flatMap { $0.value } } }
    }
    
    var days: some View {
        ForEach(monthWorkDictionary.keys.sorted(by: >), id: \.self) { month in
            if let weekWorkDictionary = monthWorkDictionary[month] {
                EntryWeekItem(groupingBy: $groupingBy, weekWorkEntityDictionary: weekWorkDictionary)
            }
        }
    }
    
    var months: some View {
        ForEach(monthWorkDictionary.keys.sorted(by: <), id: \.self) { month in
            if let weekWorkDictionary = monthWorkDictionary[month] {
                // Take all the WorkEntities from this month and grouped them by jobs
                let workEntityArray = weekWorkDictionary.flatMap { $0.value.flatMap { $0.value } }
                if let workEntity = workEntityArray.first {
                    Section(getMonthNameAndYear(workEntity: workEntity)) {
                        ForEach(getWorkEntriesGroupedByJob(workEntityArray: workEntityArray), id: \.self) { workEntry in
                            EntryItem(workEntry: workEntry)
                        }
                    }
                }
            }
        }
    }
    
    var weeks: some View {
        Text("")
    }
    
    var jobs: some View {
        Text("")
    }
    
    var body: some View {
        switch groupingBy {
        case .Months:
            months
        default: days
        }
    }
    
    private func playground(weekWorkDictionary: [Int : [Int : [WorkEntity]]]) {
        let value = weekWorkDictionary.flatMap { $0.value.flatMap { $0.value } }
        let groupedByWeek = value.sliced(by: [.weekOfYear], for: \.safeStart)
    }
    
    private func getWorkEntriesGroupedByJob(workEntityArray: [WorkEntity]) -> [WorkEntry] {
        let workEntities = workEntityArray.compactMap { $0.job == nil ? nil : $0 }
        let grouping = Dictionary(grouping: workEntities) { $0.job! }
        let workEntries = grouping.map { WorkEntry(job: $0.key, work: $0.value) }
        return workEntries
    }
    
    private func getMonthNameAndYear(workEntity: WorkEntity) -> String {
        return workEntity.safeStart.MMM_yyyy
    }
}

struct EntryMonthItem_Previews: PreviewProvider {
    static var previews: some View {
        EntryMonthItem(groupingBy: .constant(.Days), monthWorkDictionary: .init())
    }
}
