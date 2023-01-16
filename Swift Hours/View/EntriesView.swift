//
//  EntriesView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct EntryWeekItem: View {
    
    let weeksArray: [Int: [Int: [WorkEntity]]]
    
    var body: some View {
        ForEach(weeksArray.keys.sorted(by: >), id: \.self) { weekKey in
            if let dayArray = weeksArray[weekKey] {
                EntryDayItem(dayArray: dayArray)
            }
        }
    }
}

struct EntryDayItem: View {
    
    let dayArray: [Int : [WorkEntity]]
    
    var body: some View {
        ForEach(dayArray.keys.sorted(by: >), id: \.self) { dayKey in
            if let dayNumber = Int(dayKey.description) {
                Section(playground(dayOfWeek: dayNumber)) {
                    if let workEntityArray = dayArray[dayKey] {
                        ForEach(playground2(workEntityArray: workEntityArray), id: \.self) { workEntry in
                            EntryItem(workEntry: workEntry)
                        }
                    }
                }
            }
        }
    }
    
    func playground(dayOfWeek: Int) -> String {
        let calendar = Calendar.current
        let today = Date()
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: today)
        dateComponents.weekday = dayOfWeek
        let date = calendar.date(from: dateComponents)
        return date?.EEEE ?? ""
    }
    
    func playground2(workEntityArray: [WorkEntity]) -> [WorkEntry] {
        let grouping = Dictionary(grouping: workEntityArray) { $0.job! }
        let workEntries = grouping.map { WorkEntry(job: $0.key, work: $0.value) }
        return workEntries
    }
}

struct EntriesView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: WorkEntity.entity(), sortDescriptors: [])
    private var work: FetchedResults<WorkEntity>
    
    @State var workEntry: [Int: [Int:[WorkEntry]]] = .init()
    
    @State var workByYearArray: [Int: [Int: [Int: [WorkEntity]]]] = .init()
    
    private var workGroupedByYear: [Date: [FetchedResults<WorkEntity>.Element]] {
        let workArray = work.map { $0 }
        let group = workArray.sliced(by: [.year], for: \.safeStart)
        return group
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(workByYearArray.keys.sorted(by: >), id: \.self) { year in
                    if let weeksArray = workByYearArray[year] {
                        EntryWeekItem(weeksArray: weeksArray)
                    }
                }
            }
            .onAppear {
//                initilizer()
//                initilizer2()
                initilizer3()
//                initilizer4()
            }
        }
    }
    
    func timeBetween(work: WorkEntity) -> DateComponents {
        let date1 = work.safeStart
        let date2 = work.safeEnd
        let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: date1, to: date2)
        return component
    }
    
    func initilizer() {
        let workArray = Array(work)
        let calendar = Calendar.current
        let workByYearArray_ = workArray.sliced(by: [.year], for: \.safeStart)
        for (yearDate, workByWeekArray) in workByYearArray_ {
            let yearComponent = calendar.component(.year, from: yearDate)
            if let yearNumber = Int(yearComponent.description) {
                Logger.log("Year - \(yearNumber.description)")
                workByYearArray[yearNumber] = .init()
                let groupedByWeek = workByWeekArray.sliced(by: [.weekOfYear], for: \.safeStart)
                for (weekDate, wrkArray) in groupedByWeek {
                    let weekComponent = calendar.component(.weekOfYear, from: weekDate)
                    if let weekNumber = Int(weekComponent.description) {
                        Logger.log("Week - \(weekNumber.description)")
                        workByYearArray[yearNumber]?[weekNumber] = .init()
                        let groupedByDay = wrkArray.sliced(by: [.weekday], for: \.safeStart)
                        for (dayDate, wrkDayArray) in groupedByDay {
                            let dayComponent = calendar.component(.weekday, from: dayDate)
                            if let dayNumber = Int(dayComponent.description) {
                                workByYearArray[yearNumber]?[weekNumber]?[dayNumber] = wrkDayArray
                                Logger.log("Day - \(dayNumber.description)")
                                Logger.log("Work Events - \(wrkDayArray.count.description)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func initilizer2() {
        let calendar = Calendar.current
        for wrk in work {
            let year = calendar.component(.year, from: wrk.safeStart)
            let week = calendar.component(.weekOfYear, from: wrk.safeStart)
            let day = calendar.component(.weekday, from: wrk.safeStart)
            if workByYearArray[year] == nil {
                workByYearArray[year] = [:]
            }
            if workByYearArray[year]?[week] == nil {
                workByYearArray[year]?[week] = [:]
            }
            if workByYearArray[year]?[week]?[day] == nil {
                workByYearArray[year]?[week]?[day] = []
            }
            workByYearArray[year]?[week]?[day]?.append(wrk)
        }
    }
    
    func initilizer3() {
        workByYearArray = [:]
        let workArray = Array(work).sorted { $0.safeStart < $1.safeStart }
        let calendar = Calendar.current
        var currentYear = -1
        var currentWeek = -1
        var currentDay = -1
        for wrk in workArray {
            let year = calendar.component(.year, from: wrk.safeStart)
            let week = calendar.component(.weekOfYear, from: wrk.safeStart)
            let day = calendar.component(.weekday, from: wrk.safeStart)
            if year != currentYear {
                currentYear = year
                currentWeek = -1
                currentDay = -1
            }
            if week != currentWeek {
                currentWeek = week
                currentDay = -1
            }
            if day != currentDay {
                currentDay = day
            }
            if workByYearArray[year] == nil {
                workByYearArray[year] = [:]
            }
            if workByYearArray[year]?[week] == nil {
                workByYearArray[year]?[week] = [:]
            }
            if workByYearArray[year]?[week]?[day] == nil {
                workByYearArray[year]?[week]?[day] = []
            }
            workByYearArray[year]?[week]?[day]?.append(wrk)
        }
    }
    
    func initilizer4() {
        let workArray = Array(work)
        let calendar = Calendar.current
        workByYearArray = [:]
        for wrk in workArray {
            let year = calendar.component(.year, from: wrk.safeStart)
            let week = calendar.component(.weekOfYear, from: wrk.safeStart)
            let day = calendar.component(.weekday, from: wrk.safeStart)
            if workByYearArray[year] == nil {
                workByYearArray[year] = [:]
            }
            if workByYearArray[year]?[week] == nil {
                workByYearArray[year]?[week] = [:]
            }
            if workByYearArray[year]?[week]?[day] == nil {
                workByYearArray[year]?[week]?[day] = []
            }
            workByYearArray[year]?[week]?[day]?.append(wrk)
        }
    }
}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView()
    }
}

extension Array {
    func sliced(by dateComponents: Set<Calendar.Component>, for key: KeyPath<Element, Date>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur[keyPath: key])
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}

extension Date {
    func timeBetween(date: Date) -> DateComponents {
        let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: date)
        return component
    }
}
