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
        let timestamp = Date().description(with: .current)
        print("[\(timestamp)] [\(level.rawValue)] [\(fileName):\(line) \(function)] \(message)")
    }
}
