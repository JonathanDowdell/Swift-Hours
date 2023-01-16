//
//  EntriesView.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/10/23.
//

import SwiftUI



struct EntriesView: View {
    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(entity: WorkEntity.entity(), sortDescriptors: [])
    private var workEntities: FetchedResults<WorkEntity>
    
    @State private var yearWorkEntityDictionary: [Int: [Int: [Int: [WorkEntity]]]] = [:]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(yearWorkEntityDictionary.keys.sorted(by: >), id: \.self) { year in
                    if let weeksArray = yearWorkEntityDictionary[year] {
                        EntryWeekItem(weekWorkEntityDictionary: weeksArray)
                    }
                }
            }
            .navigationBarTitle("Days")
            .searchable(text: $searchText)
            .onAppear {
                initilizer()
            }
        }
    }
    
    func initilizer() {
        let calendar = Calendar.current
        yearWorkEntityDictionary = [:]
        for wrk in workEntities {
            let year = calendar.component(.year, from: wrk.safeStart)
            let week = calendar.component(.weekOfYear, from: wrk.safeStart)
            let day = calendar.component(.weekday, from: wrk.safeStart)
            if yearWorkEntityDictionary[year] == nil {
                yearWorkEntityDictionary[year] = [:]
            }
            if yearWorkEntityDictionary[year]?[week] == nil {
                yearWorkEntityDictionary[year]?[week] = [:]
            }
            if yearWorkEntityDictionary[year]?[week]?[day] == nil {
                yearWorkEntityDictionary[year]?[week]?[day] = []
            }
            yearWorkEntityDictionary[year]?[week]?[day]?.append(wrk)
        }
    }
}

struct EntriesView_Previews: PreviewProvider {
    static var previews: some View {
        EntriesView()
    }
}
