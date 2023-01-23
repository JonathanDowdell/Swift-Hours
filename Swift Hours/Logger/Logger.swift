//
//  Logger.swift
//  Swift Hours
//
//  Created by Mettaworldj on 1/13/23.
//

import Foundation

enum LogLevel: String {
    case verbose = "VERBOSE"
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

struct Logger {
    static func log(_ message: String, level: LogLevel = .debug, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = file.split(separator: "/").last ?? ""
        let timestamp = Date().dd_MM_yyyy_hh_mm_a
        print("[\(timestamp)] [\(level.rawValue)] [\(fileName):\(line) \(function)] \(message)")
    }
}

extension Date {
    var dd_MM_yyyy_hh_mm_a: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    var EEEE: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    var MMM_yyyy: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
