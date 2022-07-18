//
//  MetricsInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Prometheus

@propertyWrapper
public struct MetricsInstance: DynamicProperty {
    
    public init() {}
    
    public var wrappedValue: PrometheusClient {
        get {
            MetricsWrapper.metrics!
        }
    }
}
