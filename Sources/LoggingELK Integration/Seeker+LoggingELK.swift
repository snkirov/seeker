//
//  Seeker+LoggingELK.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Logging
import LoggingELK
import Seeker

// MARK: - Logger methods
extension Seeker {
    /// Default logging setup method.
    /// Initialises the default log handler and bootstraps the logging system with it.
    /// Creates the logger and assigns it to the logger factory.
    /// - Parameters:
    ///   - hostname: Host where the logstash instance is hosted. `localhost` by default.
    ///   - port: Port where the logstash instance is hosted. `5001` by default.
    ///   - shouldLogToConsole: Whether logging to the console should be enabled. Useful for debugging. `True` by default.
    public static func setupLoggingELKLogger(hostname: String = "localhost", port: Int = 5001, shouldLogToConsole: Bool = true) {
        LogstashLogHandler.setup(hostname: hostname, port: port)
        
        LoggingSystem.bootstrap { label in
            guard shouldLogToConsole else {
                return LogstashLogHandler(label: label)
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
        setupLogger(for: logger)
    }
}
