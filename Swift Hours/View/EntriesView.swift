//
//  EntriesView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI

//struct EntriesGroupedByMonth: View {
//    
//}

struct EntriesView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: WorkEntity.entity(), sortDescriptors: [])
    private var workEntities: FetchedResults<WorkEntity>
    
    @FetchRequest(entity: JobEntity.entity(), sortDescriptors: [])
    private var jobs: FetchedResults<JobEntity>
    
    @State private var yearWorkEntityDictionary: [Int: [Int: [Int: [Int: [WorkEntity]]]]] = [:]
    
    @AppStorage("lastGrouping") private var groupingBy: GroupingBy = .Days
    
    @State private var searchText = ""
    
    @State private var showGrouping = false
    
    @State private var firstLoad = true
    
    var daysSection: some View {
        Text("Days")
    }
    
    var weeksSection: some View {
        ForEach(viewModel.workEntryByWeek, id: \.self) { weekEntry in
            Section(getStartAndEndOfWeekDate(date: weekEntry.date)) {
                ForEach(weekEntry.workEntry, id: \.self) { week in
                    EntryItem(workEntry: week)
                }
            }
        }
    }
    
    private func getStartAndEndOfWeekDate(date: Date) -> String {
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
    
    var dateFormatter: DateFormatter {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM yyyy"
        return startDateFormatter
    }
    
    var monthsSection: some View {
        
        ForEach(viewModel.workEntryByMonth, id: \.self) { monthWorkEntry in
            Section(dateFormatter.string(from: monthWorkEntry.date)) {
                ForEach(monthWorkEntry.workEntry, id: \.self) { workEntry in
                    EntryItem(workEntry: workEntry)
                }
            }
        }
//        ForEach(viewModel.monthWorkEntityDictionary, id: \.self) { month in
//            Text("Hello World")
//                .onAppear {
//                    print(month)
//                }
//        }
    }
    
    var jobsSection: some View {
        ForEach(viewModel.workEntryByJob, id: \.self) { workEntry in
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
//                EntryYearItem(yearWorkEntityDictionary: yearWorkEntityDictionary, viewBy: $groupingBy)
            }
            .navigationBarTitle(groupingBy.rawValue)
            .searchable(text: $searchText)
            .onAppear {
                initilizer()
                if firstLoad {
                    loadCSV()
                    firstLoad = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            withAnimation() {
                                showGrouping.toggle()
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }

                        if showGrouping {
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
    
    func initilizer() {
        let calendar = Calendar.current
        yearWorkEntityDictionary = [:]
        for workEntity in workEntities {
            let year = calendar.component(.year, from: workEntity.safeStart)
            let month = calendar.component(.month, from: workEntity.safeStart)
            let week = calendar.component(.weekOfYear, from: workEntity.safeStart)
            let day = calendar.component(.weekday, from: workEntity.safeStart)
            
            if yearWorkEntityDictionary[year] == nil {
                yearWorkEntityDictionary[year] = [:]
            }
            
            if yearWorkEntityDictionary[year]?[month] == nil {
                yearWorkEntityDictionary[year]?[month] = [:]
            }
            
            if yearWorkEntityDictionary[year]?[month]?[week] == nil {
                yearWorkEntityDictionary[year]?[month]?[week] = [:]
            }
            
            if yearWorkEntityDictionary[year]?[month]?[week]?[day] == nil {
                yearWorkEntityDictionary[year]?[month]?[week]?[day] = []
            }
            
            yearWorkEntityDictionary[year]?[month]?[week]?[day]?.append(workEntity)
        }
    }
    
    func loadCSV() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        if let path = Bundle.main.path(forResource: "SwiftHours", ofType: "csv") {
            do {
                let csvString = try String(contentsOfFile: path, encoding: .utf8)
                let rows = csvString.components(separatedBy: "\n")
                var startDate = 1
                for row in rows {
                    let rowArray = row.components(separatedBy: ",")
                    guard rowArray.count > 1 else {
                        return
                    }
                    Logger.log(rowArray.description)
                    
                    if let job = jobs.first(where: { $0.name == rowArray[2] }) {
                        let work = WorkEntity(context: moc)
                        work.start = dateFormatter.date(from: "12-\(startDate)-2022 05:00 AM")
                        work.end = dateFormatter.date(from: "12-\(startDate)-2022  0\(Int.random(in: 6 ... 9)):00 AM")
                        job.addToWork(work)
                        work.job = job
                    } else {
                        let job = JobEntity(context: moc)
                        job.schedule = rowArray[0]
                        job.rate = Double(rowArray[1]) ?? 0.0
                        job.name = rowArray[2]
                        job.id = UUID()
                        job.estimatedTaxRate = NSDecimalNumber(string: rowArray[4])
                        job.clockedIn = false
                        let work = WorkEntity(context: moc)
                        work.start = dateFormatter.date(from: "12-\(startDate)-2022 05:00 AM")
                        work.end = dateFormatter.date(from: "12-\(startDate)-2022  0\(Int.random(in: 6 ... 9)):00 AM")
                        job.addToWork(work)
                        work.job = job
                    }
                    startDate += 1
                    try moc.save()
                }
            } catch {
                Logger.log(error.localizedDescription)
            }
        }
    }
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
