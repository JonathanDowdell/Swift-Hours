//
//  EntryYearItem.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/15/23.
//

import SwiftUI

struct EntryYearItem: View {
    
    private(set) var yearWorkEntityDictionary: [Int: [Int: [Int: [Int: [WorkEntity]]]]] = [:]
    
    @Binding var viewBy: EntriesView.GroupingBy
    
    var body: some View {
        ForEach(yearWorkEntityDictionary.keys.sorted(by: >), id: \.self) { year in
            if let monthWorkDictionary = yearWorkEntityDictionary[year] {
                EntryMonthItem(groupingBy: $viewBy, monthWorkDictionary: monthWorkDictionary)
            }
        }
    }
    
    
//    private func getMonthandYear(month: Int, year: Int) -> String {
//        let calendar = Calendar.current
//        let today = Date()
//        var dateComponents = calendar.dateComponents([.year, .month], from: today)
//        dateComponents.month = month
//        dateComponents.year = year
//        let date = calendar.date(from: dateComponents)
//        return date?.MMM_yyyy ?? ""
//    }
//    
//    func getMonthandYear(from date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM yyyy"
//        return dateFormatter.string(from: date)
//    }
}

struct EntryYearItem_Previews: PreviewProvider {
    static var previews: some View {
        EntryYearItem(viewBy: .constant(.Days))
    }
}
