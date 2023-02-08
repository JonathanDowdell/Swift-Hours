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
    
    func getDayName() -> String {
        let calendar = Calendar.current
        let date = self // your date could be any date
        let weekday = calendar.component(.weekday, from: date)
        let weekdays = calendar.shortWeekdaySymbols
        let dayOfWeek = weekdays[weekday - 1]
        return dayOfWeek
    }
    
    func getStartAndEndOfWeekDate() -> String {
        
        let calendar = Calendar.current
        let dayName = self.getDayName()
        
        var startOfWeek: Date?
        var endOfWeek: Date?
        
        switch dayName {
        case "Mon":
            startOfWeek = calendar.date(byAdding: .day, value: 0, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 6, to: self)
        case "Tue":
            startOfWeek = calendar.date(byAdding: .day, value: -1, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 5, to: self)
        case "Wed":
            startOfWeek = calendar.date(byAdding: .day, value: -2, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 4, to: self)
        case "Thu":
            startOfWeek = calendar.date(byAdding: .day, value: -3, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 3, to: self)
        case "Fri":
            startOfWeek = calendar.date(byAdding: .day, value: -4, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 2, to: self)
        case "Sat":
            startOfWeek = calendar.date(byAdding: .day, value: -5, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 1, to: self)
        case "Sun":
            startOfWeek = calendar.date(byAdding: .day, value: -6, to: self)
            endOfWeek = calendar.date(byAdding: .day, value: 0, to: self)
        default: break
            
        }
        
        let startString = DateFormatter.MMMdd_.string(from: startOfWeek!)
        let endString = DateFormatter.dd_yyyy.string(from: endOfWeek!)
        
        return startString + endString
    }
    
    func time(relativeTo referenceDate: Date) -> String {
        let seconds = Int(referenceDate.timeIntervalSince(self))
        let timeRelation = seconds < 0 ? "from now" : "ago"
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        let absSeconds = abs(seconds)
        
        if absSeconds < minute {
            return "now"
        } else if absSeconds < hour {
            return "\(absSeconds / minute) minutes \(timeRelation)"
        } else if absSeconds < day {
            return "\(absSeconds / hour) hours \(timeRelation)"
        } else if absSeconds < week {
            return "\(absSeconds / day) days \(timeRelation)"
        }
        
        return "\(absSeconds / week) weeks \(timeRelation)"
    }
}
