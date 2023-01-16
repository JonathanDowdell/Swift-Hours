//
//  EntryDayItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/15/23.
//

import SwiftUI

struct EntryDayItem: View {
    
    private(set) var dayWorkEntityDictionary: [Int : [WorkEntity]]
    
    var body: some View {
        ForEach(dayWorkEntityDictionary.keys.sorted(by: >), id: \.self) { dayKey in
            if let dayNumber = Int(dayKey.description) {
                Section(getDayOfTheWeekName(dayOfWeekNumber: dayNumber)) {
                    if let workEntityArray = dayWorkEntityDictionary[dayKey] {
                        ForEach(getWorkEntriesGroupedByJob(workEntityArray: workEntityArray), id: \.self) { workEntry in
                            EntryItem(workEntry: workEntry)
                        }
                    }
                }
            }
        }
    }
    
    private func getDayOfTheWeekName(dayOfWeekNumber: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        dateComponents.weekday = dayOfWeekNumber
        let date = calendar.date(from: dateComponents)
        return date?.EEEE ?? ""
    }
    
    private func getWorkEntriesGroupedByJob(workEntityArray: [WorkEntity]) -> [WorkEntry] {
        let grouping = Dictionary(grouping: workEntityArray) { $0.job! }
        let workEntries = grouping.map { WorkEntry(job: $0.key, work: $0.value) }
        return workEntries
    }
}

struct EntryDayItem_Previews: PreviewProvider {
    static var previews: some View {
        EntryDayItem(dayWorkEntityDictionary: .init())
    }
}
