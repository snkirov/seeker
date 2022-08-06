//
//  File.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import SwiftUI
import Prometheus

@propertyWrapper
public struct PromMetricsInstance: DynamicProperty {
    
    public init() {}
    
    public var wrappedValue: PrometheusClient {
        get { Seeker.promMetrics }
    }
}
