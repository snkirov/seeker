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
        
        // Tracer Setup
        Seeker.tracerSetup(serviceName: deviceId)
        
        // Metrics Setup
        Seeker.metricsSetup(serviceName: deviceId)
        
        LoggerFactory.logger?.info("App Started!")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }
    }
}
