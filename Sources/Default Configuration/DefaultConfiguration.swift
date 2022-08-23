//
//  DefaultConfiguration.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Seeker
import LoggingELK_Integration
import SwiftPrometheus_Integration
import OpenTelemetry_Integration

/// This protocol defines the interface of the Seeker Default Configuration product
public protocol SeekerDefaultConfigurationProtocol {
  /// Default Configuration setup method.
  /// Initialises the logger, metrics and tracer objects, by using respectively the LoggingELK, SwiftPrometheus and OpenTelemetry integration libraries.
  /// This method should be used if all supporting services are hosted on the same host and use the default ports.
  /// - Parameters:
  ///   - hostname: Host where Logstash, Prometheus PushGateway and OTel Collector instances are hosted
  ///
  static func setupDefaultConfiguration(host: String)
  
  /// Default Configuration setup method.
  /// Initialises the logger, metrics and tracer objects, by using respectively the LoggingELK, SwiftPrometheus and OpenTelemetry integration libraries.
  /// - Parameters:
  ///   - loggingHost: Host where the Logstash instance is hosted
  ///   - loggingPort: Port at which Logstash expects logs data
  ///   - metricsHost: Host where the Prometheus PushGateway instance is hosted
  ///   - metricsPort: Port at which Prometheus PushGateway  expects metrics data
  ///   - tracingHost: Host where the OTel Collector instance is hosted
  ///   - tracingPort: Port at which OTel Collector expects traces data
  static func setupDefaultConfiguration(loggingHost: String, loggingPort: Int, metricsHost: String, metricsPort: Int, tracingHost: String, tracingPort: Int)
  
  /// Default Configuration teardown method.
  /// Tears down the metrics and tracer objects.
  static func teardownDefaultConfiguration()
}

/// Default Configuration Methods
extension Seeker: SeekerDefaultConfigurationProtocol {
  public static func setupDefaultConfiguration(host: String) {
    setupDefaultConfiguration(loggingHost: host, metricsHost: host, tracingHost: host)
  }
  
  public static func setupDefaultConfiguration(loggingHost: String, loggingPort: Int = 5001, metricsHost: String, metricsPort: Int = 9091, tracingHost: String, tracingPort: Int = 4317) {
    setupLoggingELKLogger(hostname: loggingHost, port: loggingPort)
    setupSwiftPrometheusMetrics(hostname: metricsHost, port: metricsPort)
    setupOpenTelemetryTracer(hostname: tracingHost, port: UInt(tracingPort))
  }
  
  public static func teardownDefaultConfiguration() {
    teardownLogger()
    teardownSwiftPrometheusMetrics()
    teardownOpenTelemetrytracer()
  }
}
