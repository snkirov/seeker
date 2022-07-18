//
//  Seeker.swift
//  Seeker
//
//  Created by Svilen Kirov on 6.06.22.
//

import Foundation
import Logging
import LoggingELK
import Metrics
import Prometheus
import Tracing

public struct Seeker {
    // TODO: Check if it is really necessary
    /// Necessary so that we can shutdown the process.
    private static var tracehandler: TraceHandler?
    /// Provides identification for the current application. By default the same identification is used for logs, metrics and traces.
    private static var identificationService: IdentificationService = DefaultIdentificationService()
    
    /// Changes the identification service implementation to the newly provided one.
    /// - Parameter newIdentificationService: The new identification service.
    public static func setIdentificationService(_ newIdentificationService: IdentificationService) {
        identificationService = newIdentificationService
    }
}

// MARK: - Logger methods
extension Seeker {
    /// Default logging setup method.
    /// Initialises the default log handler and bootstraps the logging system with it.
    /// Creates the logger and assigns it to the logger factory.
    /// - Parameters:
    ///   - hostname: Host where the logstash instance is hosted. `localhost` by default.
    ///   - port: Port where the logstash instance is hosted. `5001` by default.
    ///   - shouldLogToConsole: Whether logging to the console should be enabled. Useful for debugging. `True` by default.
    public static func loggerSetup(hostname: String = "localhost", port: Int = 5001, shouldLogToConsole: Bool = true) {
        LogstashLogHandler.setup(hostname: hostname, port: port)
        
        LoggingSystem.bootstrap { label in
            guard shouldLogToConsole else {
                return MultiplexLogHandler([LogstashLogHandler(label: label)])
            }
            return MultiplexLogHandler(
                [
                    LogstashLogHandler(label: label),
                    StreamLogHandler.standardOutput(label: label)
                ]
            )
        }
        
        let deviceId = identificationService.getRandomizedDeviceId()
        let logger = Logger(label: deviceId)
        LoggerWrapper.logger = logger
    }
    
    /// Custom logging setup method.
    /// Must be called after the custom log handler is initialised and the logger object is created.
    /// Not calling it and using the package will result in a crash.
    /// - Parameter logger: The logger object to be used.
    public static func customLoggerSetup(for logger: Logger) {
        LoggerWrapper.logger = logger
    }
}

// MARK: - Metrics methods
extension Seeker {
    /// Metrics setup method.
    /// Initialises the Prometheus Client and bootstraps the metrics system with it.
    /// Starts the pushToGateway process and assigns the prom client to the metrics factory.
    /// - Parameters:
    ///   - hostname: Host where the prometheus push gateway instance is hosted. `localhost` by default.
    ///   - port: Port where the prometheus push gateway instance is hosted. `9091` by default.
    public static func metricsSetup(hostname: String = "localhost", port: Int? = 9091) {
        let myProm = PrometheusClient()
        MetricsSystem.bootstrap(PrometheusMetricsFactory(client: myProm))
        let deviceId = identificationService.getRandomizedDeviceId()
        myProm.pushToGateway(host: hostname, port: port, jobName: deviceId)
        MetricsWrapper.metrics = myProm
    }
    
    /// Metrics teardown method.
    /// Stops the PushToGateway process and removes the metrics factory instance.
    public static func metricsTeardown() {
        MetricsWrapper.metrics?.tearDownPushToGateway()
        MetricsWrapper.metrics = nil
    }
}

// MARK: - Tracer methods
extension Seeker {
    /// Default tracer setup method.
    /// Initialises a Tracehandler instance. Further setup is done in the initialiser.
    /// - Parameters:
    ///   - hostname: Host where the otel collector instance is hosted. `localhost` by default.
    ///   - port: Port where the otel collector instance is hosted. `4316` by default.
    public static func tracerSetup(hostname: String = "localhost", port: UInt = 4317) {
        let deviceId = identificationService.getRandomizedDeviceId()
        tracehandler = TraceHandler(serviceName: deviceId, hostname: hostname, port: port)
    }
    
    /// Default tracer teardown method.
    public static func tracerTeardown() {
        tracehandler?.shutdown()
        tracehandler = nil
    }
    
    /// Custom tracer setup method.
    /// Must be called after the custom trace handler is initialised and the isntrumentation system is bootstrapped.
    /// Not calling it and using the package will result in a crash.
    /// - Parameter for: The tracer object to be used.
    public static func customTracerSetup(for tracer: Tracer) {
        TracerWrapper.tracer = tracer
    }
}

// MARK: - UIKit getters
extension Seeker {
    
    /// Provides the currently used logger instance.
    /// - Returns: The currently used logger instance.
    public static func getLogger() -> Logger {
        LoggerWrapper.logger!
    }
    
    /// Provides the currently used metrics instance.
    /// - Returns: The currently used metrics instance.
    public static func getMetrics() -> PrometheusClient {
        MetricsWrapper.metrics!
    }
    
    /// Provides the currently used tracer instance.
    /// - Returns: The currently used tracer instance.
    public static func getTracer() -> Tracer {
        TracerWrapper.tracer!
    }
}
