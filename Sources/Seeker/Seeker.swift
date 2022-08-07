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
    
    // TODO: Fix public here, either remove setter, or remove public
    /// Provides identification for the current application. By default the same identification is used for logs, metrics and traces.
    public static var identificationService: IdentificationService = DefaultIdentificationService()
    
    static var _logger: Logger?
    
    static var _metrics: MetricsFactory?
    
    static var _tracer: Tracer?
    
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
        _logger = logger
        logger.info("Version: ")
        logger.info("IsFirstLaunch: ")
    }
    
    public static func teardownLogger() {
        _logger = nil
    }
    
    /// Custom metrics setup method.
    /// Must be called after the custom metrics handler is initialised and configured..
    /// Not calling it and using the package will result in an error.
    /// - Parameter for: The metrics object to be used.
    public static func setupMetrics(for metrics: MetricsFactory) {
        _metrics = metrics
    }
    
    public static func teardownMetrics() {
        _metrics = nil
    }
    
    /// Custom tracer setup method.
    /// Must be called after the custom trace handler is initialised and the isntrumentation system is bootstrapped.
    /// Not calling it and using the package will result in a crash.
    /// - Parameter for: The tracer object to be used.
    public static func setupTracer(for tracer: Tracer) {
        _tracer = tracer
    }
    
    public static func teardownTracer() {
        _tracer = nil
    }
}

// MARK: - UIKit getters
extension Seeker {
    
    /// Provides the currently used logger instance.
    public static var logger: Logger {
        guard let logger = _logger else {
            fatalError("Logger object not initialised")
        }
        return logger
    }
    
    /// Provides the currently used metrics instance.
    public static var metrics: MetricsFactory {
        guard let metrics = _metrics else {
            fatalError("Metrics object not initialised")
        }
        return metrics
    }
    
    /// Provides the currently used tracer instance.
    public static var tracer: Tracer {
        guard let tracer = _tracer else {
            fatalError("Tracer object not initialised")
        }
        return tracer
    }
    
}
