//
//  EntriesView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

struct EntriesView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @AppStorage("lastGrouping") private var groupingBy: GroupingBy = .Days
    
    var daysSection: some View {
        Text("Days")
    }
    
    var weeksSection: some View {
        ForEach(viewModel.workEntryByWeek.sorted(by: { $0.date > $1.date }), id: \.self) { weekEntry in
            Section(weekEntry.date.getStartAndEndOfWeekDate()) {
                ForEach(weekEntry.workEntry.sortedByName(), id: \.self) { week in
                    EntryItem(workEntry: week)
                }
            }
        }
    }
    
    var monthsSection: some View {
        ForEach(viewModel.workEntryByMonth, id: \.self) { monthWorkEntry in
            Section(monthWorkEntry.date.MMM_yyyy) {
                ForEach(monthWorkEntry.workEntry.sortedByName(), id: \.self) { workEntry in
                    EntryItem(workEntry: workEntry)
                }
            }
        }
    }
    
    var jobsSection: some View {
        ForEach(viewModel.workEntryByJob.sortedByName(), id: \.self) { workEntry in
            EntryItem(workEntry: workEntry)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                switch groupingBy {
                case .Days: daysSection
                case .Weeks: weeksSection
                case .Months: monthsSection
                case .Jobs: jobsSection
                }
            }
            .navigationBarTitle(groupingBy.rawValue)
            .searchable(text: $viewModel.searchText)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            withAnimation() {
                                viewModel.showGrouping.toggle()
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }

                        if viewModel.showGrouping {
                            Picker("Group By", selection: $groupingBy) {
                                ForEach(GroupingBy.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
            }
        }
    }
    
//    func initilizer() {
//        let calendar = Calendar.current
//        yearWorkEntityDictionary = [:]
//        for workEntity in workEntities {
//            let year = calendar.component(.year, from: workEntity.safeStart)
//            let month = calendar.component(.month, from: workEntity.safeStart)
//            let week = calendar.component(.weekOfYear, from: workEntity.safeStart)
//            let day = calendar.component(.weekday, from: workEntity.safeStart)
//
//            if yearWorkEntityDictionary[year] == nil {
//                yearWorkEntityDictionary[year] = [:]
//            }
//
//            if yearWorkEntityDictionary[year]?[month] == nil {
//                yearWorkEntityDictionary[year]?[month] = [:]
//            }
//
//            if yearWorkEntityDictionary[year]?[month]?[week] == nil {
//                yearWorkEntityDictionary[year]?[month]?[week] = [:]
//            }
//
//            if yearWorkEntityDictionary[year]?[month]?[week]?[day] == nil {
//                yearWorkEntityDictionary[year]?[month]?[week]?[day] = []
//            }
//
//            yearWorkEntityDictionary[year]?[month]?[week]?[day]?.append(workEntity)
//        }
//    }
//
//    func loadCSV() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
//        if let path = Bundle.main.path(forResource: "SwiftHours", ofType: "csv") {
//            do {
//                let csvString = try String(contentsOfFile: path, encoding: .utf8)
//                let rows = csvString.components(separatedBy: "\n")
//                var startDate = 1
//                for row in rows {
//                    let rowArray = row.components(separatedBy: ",")
//                    guard rowArray.count > 1 else {
//                        return
//                    }
//                    Logger.log(rowArray.description)
//
//                    if let job = jobs.first(where: { $0.name == rowArray[2] }) {
//                        let work = WorkEntity(context: moc)
//                        work.start = dateFormatter.date(from: "12-\(startDate)-2022 05:00 AM")
//                        work.end = dateFormatter.date(from: "12-\(startDate)-2022  0\(Int.random(in: 6 ... 9)):00 AM")
//                        job.addToWork(work)
//                        work.job = job
//                    } else {
//                        let job = JobEntity(context: moc)
//                        job.schedule = rowArray[0]
//                        job.rate = Double(rowArray[1]) ?? 0.0
//                        job.name = rowArray[2]
//                        job.id = UUID()
//                        job.estimatedTaxRate = NSDecimalNumber(string: rowArray[4])
//                        job.clockedIn = false
//                        let work = WorkEntity(context: moc)
//                        work.start = dateFormatter.date(from: "12-\(startDate)-2022 05:00 AM")
//                        work.end = dateFormatter.date(from: "12-\(startDate)-2022  0\(Int.random(in: 6 ... 9)):00 AM")
//                        job.addToWork(work)
//                        work.job = job
//                    }
//                    startDate += 1
//                    try moc.save()
//                }
//            } catch {
//                Logger.log(error.localizedDescription)
//            }
//        }
//    }
}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView()
    }
}

extension EntriesView {
    enum GroupingBy: String, CaseIterable {
    case Days, Weeks, Months, Jobs
    }
}
