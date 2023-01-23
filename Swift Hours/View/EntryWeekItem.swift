//
//  EntryWeekItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/15/23.
//

import SwiftUI

struct EntryWeekItem: View {
    
    @Binding var groupingBy: EntriesView.GroupingBy
    
    private(set) var weekWorkEntityDictionary: [Int: [Int: [WorkEntity]]]
    
    var something: [WorkEntity] {
        let s = weekWorkEntityDictionary.flatMap { $0.value.flatMap { $0.value } }
        return s
    }
    
    var daySection: some View {
        ForEach(weekWorkEntityDictionary.keys.sorted(by: >), id: \.self) { weekKey in
            if let dayWorkEntityDictionary = weekWorkEntityDictionary[weekKey] {
                EntryDayItem(dayWorkEntityDictionary: dayWorkEntityDictionary)
            }
        }
    }
    
    var weekSection: some View {
        Group {
            Text("Hello World")
                .onAppear {
                    let something = weekWorkEntityDictionary.flatMap { $0.value }.flatMap { $0.value }
                    for weekKey in weekWorkEntityDictionary.keys {
                        let a = weekWorkEntityDictionary[weekKey]?.values.flatMap { $0 }
//                        if let a {
//                            Logger.log(a.description)
//                        }
                    }
                }
        }
//        Group {
//            let s = weekWorkEntityDictionary.flatMap { $0.value.flatMap { $0.value } }
//            ForEach(getWorkEntriesGroupedByJob(workEntityArray: s), id: \.self) { workEntry in
//                EntryItem(workEntry: workEntry)
//            }
//        }
    }
    
    var body: some View {
        switch groupingBy {
        case .Weeks: weekSection
        default: daySection
        }
    }
    
    func playground() {
        
        
    }
    
    private func getWorkEntriesGroupedByJob(workEntityArray: [WorkEntity]) -> [WorkEntry] {
        let workEntities = workEntityArray.compactMap { $0.job == nil ? nil : $0 }
        let grouping = Dictionary(grouping: workEntities) { $0.job! }
        let workEntries = grouping.map { WorkEntry(job: $0.key, work: $0.value) }
        return workEntries
    }
    
    
    private func getStartAndEndOfWeekDate(workEntity: WorkEntity) -> String {
        
        let date = workEntity.safeStart // current date
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek!)

        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM dd-"
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "dd yyyy"

        let startString = startDateFormatter.string(from: startOfWeek!)
        let endString = endDateFormatter.string(from: endOfWeek!)
        
        return startString + endString
    }
}

struct EntryWeekItem_Previews: PreviewProvider {
    static var previews: some View {
        EntryWeekItem(groupingBy: .constant(.Days), weekWorkEntityDictionary: .init())
    }
}
