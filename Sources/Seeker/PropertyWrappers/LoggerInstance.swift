//
//  LoggerInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Logging

@propertyWrapper
struct LoggerInstance: DynamicProperty {
    
    var wrappedValue: Logger {
        get {
            LoggerWrapper.logger!
        }
    }
}
