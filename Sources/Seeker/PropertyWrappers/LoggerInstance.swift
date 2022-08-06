//
//  LoggerInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Logging

@propertyWrapper
public struct LoggerInstance: DynamicProperty {
    
    public init() {}
    
    public var wrappedValue: Logger {
        get {
            guard let logger = LoggerWrapper.logger else {
                fatalError("Logger object not initialised.")
            }
            return logger
        }
    }
}
