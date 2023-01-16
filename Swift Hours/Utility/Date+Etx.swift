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
}
