//
//  MonthWorkEntry.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/29/23.
//

import Foundation

struct MonthWorkEntry: Hashable {
    let date: Date
    var workEntry: [WorkEntry]
}

extension Array where Element == WorkEntry {
    func sortedByName() -> [WorkEntry] {
        return self.sorted(by: { $0.job.name ?? "A" < $1.job.name ?? "B" })
    }
}
