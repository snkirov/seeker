//
//  DefaultConfiguration.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Seeker

extension Seeker {
    public static func setupDefaultConfiguration(host: String) {
        setupDefaultConfiguration(loggingHost: host, metricsHost: host, tracingHost: host)
    }
    
    public static func setupDefaultConfiguration(loggingHost: String, loggingPort: Int = 5001, metricsHost: String, metricsPort: Int = 9091, tracingHost: String, tracingPort: Int = 4317) {
        setupLoggingELKLogger(hostname: loggingHost, port: loggingPort)
        setupSwiftPrometheusMetrics(hostname: metricsHost, port: metricsPort)
        setupOpenTelemetryTracer(hostname: tracingHost, port: UInt(tracingPort))
    }
}
