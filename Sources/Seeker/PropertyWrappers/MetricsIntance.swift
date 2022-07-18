//
//  MetricsInstance.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import SwiftUI
import Prometheus

@propertyWrapper
struct MetricsInstance: DynamicProperty {
    
    var wrappedValue: PrometheusClient {
        get {
            MetricsWrapper.metrics!
        }
    }
}
