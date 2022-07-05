//
//  PropertyWrappers.swift
//  Seeker
//
//  Created by Svilen Kirov on 6.06.22.
//

import SwiftUI
import Logging
import Metrics
import Prometheus
import Tracing

@propertyWrapper
struct LoggerInstance: DynamicProperty {
    
    var wrappedValue: Logger {
        get {
            LoggerFactory.logger!
        }
    }
}

@propertyWrapper
struct MetricsInstance: DynamicProperty {
    
    var wrappedValue: PrometheusClient {
        get {
            MetricsFactory.metrics!
        }
    }
}

@propertyWrapper
struct TracerInstance: DynamicProperty {
    
    var wrappedValue: Tracer {
        get {
            InstrumentationSystem.tracer
        }
    }
}
