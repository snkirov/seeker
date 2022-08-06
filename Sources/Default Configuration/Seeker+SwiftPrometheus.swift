//
//  File.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Metrics
import Prometheus
import Seeker

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
