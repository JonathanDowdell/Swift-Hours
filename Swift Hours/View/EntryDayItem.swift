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
            if let workEntityArray = dayWorkEntityDictionary[dayKey], let workEntity = workEntityArray.first {
                Section(getDayOfTheWeekName(workEntity: workEntity)) {
                    ForEach(getWorkEntriesGroupedByJob(workEntityArray: workEntityArray), id: \.self) { workEntry in
                        EntryItem(workEntry: workEntry)
                    }
                }
            }
        }
    }
    
    private func getDayOfTheWeekName(workEntity: WorkEntity) -> String {
        return workEntity.safeStart.EEEE
    }
    
    private func getWorkEntriesGroupedByJob(workEntityArray: [WorkEntity]) -> [WorkEntry] {
        let workEntities = workEntityArray.compactMap { $0.job == nil ? nil : $0 }
        let grouping = Dictionary(grouping: workEntities) { $0.job! }
        let workEntries = grouping.map { WorkEntry(job: $0.key, work: $0.value) }
        return workEntries
    }
}

struct EntryDayItem_Previews: PreviewProvider {
    static var previews: some View {
        EntryDayItem(dayWorkEntityDictionary: .init())
    }
}
