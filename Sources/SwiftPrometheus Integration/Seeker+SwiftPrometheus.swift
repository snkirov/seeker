//
//  File.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Metrics
import Prometheus
import Seeker

/// This protocol defines the interface of the Seeker Swift Prometheus product
public protocol SeekerPrometheusMetricsProtocol {
  /// Provides the currently used prometheus metrics instance.
  static var promMetrics: PrometheusClient { get }
  
  /// Metrics setup method.
  /// Initialises the Prometheus Client and bootstraps the metrics system with it.
  /// Starts the pushToGateway process and assigns the prom client to the metrics factory.
  /// - Parameters:
  ///   - hostname: Host where the prometheus push gateway instance is hosted.
  ///   - port: Port where the prometheus push gateway instance is hosted.
  static func setupSwiftPrometheusMetrics(hostname: String, port: Int?)
  
  /// Metrics teardown method.
  /// Stops the PushToGateway process and removes the metrics factory instance.
  static func teardownSwiftPrometheusMetrics()
}

// MARK: - SeekerPrometheusMetricsProtocol methods
extension Seeker: SeekerPrometheusMetricsProtocol {
  
  public static var promMetrics: PrometheusClient {
    guard let promMetrics = PromMetricsWrapper.metrics else {
      fatalError("Prometheus metrics object not initialised.")
    }
    return promMetrics
  }
  
  public static func setupSwiftPrometheusMetrics(hostname: String, port: Int? = 9091) {
    let myProm = PrometheusClient()
    let metricsFactory = PrometheusMetricsFactory(client: myProm)
    MetricsSystem.bootstrap(metricsFactory)
    let deviceId = identificationService.getObservabilityIdentifier()
    myProm.pushToGateway(host: hostname, port: port, jobName: deviceId)
    PromMetricsWrapper.metrics = myProm
    Seeker.setupMetrics(for: metricsFactory)
  }
  
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
