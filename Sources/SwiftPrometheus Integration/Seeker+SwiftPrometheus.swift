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
    
    public static var promMetrics: PrometheusClient {
        guard let promMetrics = PromMetricsWrapper.metrics else {
            fatalError("Prometheus metrics object not initialised.")
        }
        return promMetrics
    }
    
    /// Metrics setup method.
    /// Initialises the Prometheus Client and bootstraps the metrics system with it.
    /// Starts the pushToGateway process and assigns the prom client to the metrics factory.
    /// - Parameters:
    ///   - hostname: Host where the prometheus push gateway instance is hosted.
    ///   - port: Port where the prometheus push gateway instance is hosted. `9091` by default.
    public static func setupSwiftPrometheusMetrics(hostname: String, port: Int? = 9091) {
        let myProm = PrometheusClient()
        MetricsSystem.bootstrap(PrometheusMetricsFactory(client: myProm))
        let deviceId = identificationService.getObservabilityIdentifier()
        myProm.pushToGateway(host: hostname, port: port, jobName: deviceId)
        PromMetricsWrapper.metrics = myProm
    }
    
    /// Metrics teardown method.
    /// Stops the PushToGateway process and removes the metrics factory instance.
    public static func teardownSwiftPrometheusMetrics() {
        promMetrics.tearDownPushToGateway()
        PromMetricsWrapper.metrics = nil
    }
}

/// Wraps the currently active metrics instance.
struct PromMetricsWrapper {
    /// Defined as an optional, as to avoid instantiating it with a dummy value.
    static var metrics: PrometheusClient?
}
