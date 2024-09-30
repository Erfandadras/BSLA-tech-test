//
//  LogManager.swift
//  BSLA tech task
//
//  Created by Erfan mac mini on 9/30/24.
//


import Foundation
import os

enum LogLevel: String {
    case error = "❌❌ Error", success = "✅✅ Success", info = "✏️✏️ Info", warning = "⚠️ ⚠️ Warning"
}

struct Logger {
    static let logger = OSLog(subsystem: "sales.guru.ios.App", category: "CustomLogs")
    static func log(_ level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line, _ messages: Any...) {
        // Construct log message with source location information
        let filePart = file.components(separatedBy: "/").last ?? ""
        let logMessage = "[\(level.rawValue) >>>> on \(filePart) -> \(function) line \(line)"
        
        // Append the variadic messages to the log message
        let formattedMessage = messages.map { String(describing: $0) }.joined(separator: " + ")
        
        // Combine source location information and messages
        let finalMessage = logMessage + " msg: " + formattedMessage + "]"
        
        // Log to NSLog for local debugging
        print(finalMessage)
    }
}
