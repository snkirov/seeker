//
//  MetricsInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Metrics

@propertyWrapper
public struct MetricsInstance: DynamicProperty {
    
    public init() {}
    
    public var wrappedValue: MetricsFactory {
        get { Seeker.metrics }
    }
}
