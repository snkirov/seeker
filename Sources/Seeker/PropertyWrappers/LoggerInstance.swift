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
        get { Seeker.logger }
    }
}
