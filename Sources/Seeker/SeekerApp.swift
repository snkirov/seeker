//
//  SeekerApp.swift
//  Seeker
//
//  Created by Svilen Kirov on 3.05.22.
//

import SwiftUI

import Logging
import LoggingELK

import Metrics
import StatsdClient


@main
struct SeekerApp: App {
    
    init() {
        
        // Logger Setup
        Seeker.loggerSetup()

        // Register LogHandlers in the LoggingSystem
        LoggingSystem.bootstrap { label in
            MultiplexLogHandler(
                [
                    LogstashLogHandler(label: label),
                    StreamLogHandler.standardOutput(label: label)
                ]
            )
        }

        let deviceId = IdentificationService.getRandomizedDeviceId()
        
        let logger = Logger(label: deviceId)
        LoggerFactory.logger = logger

        // 3) we're now ready to use it
        logger.info("App Started!")
        
        // Tracer Setup
        Seeker.tracerSetup(serviceName: deviceId)
        
        // Metrics Setup
        Seeker.metricsSetup(serviceName: deviceId)
        
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
