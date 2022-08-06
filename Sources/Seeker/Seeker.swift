//
//  Seeker.swift
//  Seeker
//
//  Created by Svilen Kirov on 6.06.22.
//

import Logging
import LoggingELK
import Metrics
import Prometheus
import Tracing

public struct Seeker {
    // TODO: Check if it is really necessary
    /// Necessary so that we can shutdown the process.
    public static var tracehandler: TraceHandler?
    /// Provides identification for the current application. By default the same identification is used for logs, metrics and traces.
    public static var identificationService: IdentificationService = DefaultIdentificationService()
    
    /// Changes the identification service implementation to the newly provided one.
    /// - Parameter newIdentificationService: The new identification service.
    public static func setIdentificationService(_ newIdentificationService: IdentificationService) {
        identificationService = newIdentificationService
    }
    
    /// Custom logging setup method.
    /// Must be called after the custom log handler is initialised and the logger object is created.
    /// Not calling it and using the package will result in a crash.
    /// - Parameter logger: The logger object to be used.
    public static func setupLogger(for logger: Logger) {
        LoggerWrapper.logger = logger
    }
    
    /// Custom metrics setup method.
    /// Must be called after the custom metrics handler is initialised and configured..
    /// Not calling it and using the package will result in an error.
    /// - Parameter for: The metrics object to be used.
    public static setupMetrics(for metrics: MetricsFactory) {
        
    }
    
    /// Custom tracer setup method.
    /// Must be called after the custom trace handler is initialised and the isntrumentation system is bootstrapped.
    /// Not calling it and using the package will result in a crash.
    /// - Parameter for: The tracer object to be used.
    public static func setupTracer(for tracer: Tracer) {
        TracerWrapper.tracer = tracer
    }
}

// MARK: - UIKit getters
extension Seeker {
    
    /// Provides the currently used logger instance.
    public static var logger: Logger { LoggerWrapper.logger! }
    
    /// Provides the currently used metrics instance.
    public static var metrics: PrometheusClient { MetricsWrapper.metrics! }
    
    /// Provides the currently used tracer instance.
    public static var tracer: Tracer { TracerWrapper.tracer! }
    
}
