//
//  DateFormatter+Etx.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/30/23.
//

import Foundation

extension DateFormatter {
    static let MMM_yyyy: DateFormatter = {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM yyyy"
        return startDateFormatter
    }()
    
    static let MMMdd_: DateFormatter = {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "MMM dd-"
        return startDateFormatter
    }()
    
    static let dd_yyyy: DateFormatter = {
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "dd yyyy"
        return startDateFormatter
    }()
}
