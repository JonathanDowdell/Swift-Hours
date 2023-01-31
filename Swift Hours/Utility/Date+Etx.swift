//
//  Date+Etx.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/15/23.
//

import Foundation

extension Date {
    func timeBetween(date: Date) -> DateComponents {
        let component = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: date)
        return component
    }
    
    func getStartAndEndOfWeekDate() -> String {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek!)

        let startString = DateFormatter.MMMdd_.string(from: startOfWeek!)
        let endString = DateFormatter.dd_yyyy.string(from: endOfWeek!)
        
        return startString + endString
    }
}
