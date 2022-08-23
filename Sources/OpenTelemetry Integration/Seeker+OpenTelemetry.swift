//
//  File.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Seeker

/// This protocol defines the interface of the Seeker OpenTelemetry product
public protocol SeekerOpenTelemetryTracerProtocol {
  /// Default tracer setup method.
  /// Initialises a Tracehandler instance and attaches it to the Tracer object.
  /// Further setup is done in the tracehandler.
  /// - Parameters:
  ///   - hostname: Host where the otel collector instance is hosted.
  ///   - port: Port where the otel collector instance is hosted. `4316` by default.
  static func setupOpenTelemetryTracer(hostname: String, port: UInt)
  
  /// Default tracer teardown method.
  static func teardownOpenTelemetrytracer()
}

// MARK: - Tracer methods
extension Seeker: SeekerOpenTelemetryTracerProtocol {
  
  public static func setupOpenTelemetryTracer(hostname: String, port: UInt = 4317) {
    let deviceId = identificationService.getObservabilityIdentifier()
    TraceHandler.setup(serviceName: deviceId, hostname: hostname, port: port)
  }
  
  public static func teardownOpenTelemetrytracer() {
    TraceHandler.shutdown()
  }
}
