//
//  DefaultConfiguration.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Foundation
import Seeker

extension Seeker {
    public static func setupDefaultConfiguration(host: String) {
        setupDefaultConfiguration(loggingHost: host, metricsHost: host, tracingHost: host)
    }
    
    public static func setupDefaultConfiguration(loggingHost: String, loggingPort: Int = 5001, metricsHost: String, metricsPort: Int = 9091, tracingHost: String, tracingPort: Int = 4317) {
        loggerSetup(hostname: loggingHost, port: loggingPort)
        metricsSetup(hostname: metricsHost, port: metricsPort)
        tracerSetup(hostname: tracingHost, port: UInt(tracingPort))
    }
}
