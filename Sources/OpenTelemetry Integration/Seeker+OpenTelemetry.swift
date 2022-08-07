//
//  File.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Seeker

// MARK: - Tracer methods
extension Seeker {
    /// Default tracer setup method.
    /// Initialises a Tracehandler instance. Further setup is done in the initialiser.
    /// - Parameters:
    ///   - hostname: Host where the otel collector instance is hosted.
    ///   - port: Port where the otel collector instance is hosted. `4316` by default.
    public static func setupOpenTelemetryTracer(hostname: String, port: UInt = 4317) {
        let deviceId = identificationService.getObservabilityIdentifier()
        TraceHandler.setup(serviceName: deviceId, hostname: hostname, port: port)
    }
    
    /// Default tracer teardown method.
    public static func teardownOpenTelemetrytracer() {
        TraceHandler.shutdown()
    }
}
