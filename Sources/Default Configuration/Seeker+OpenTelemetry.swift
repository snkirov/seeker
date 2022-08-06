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
}
