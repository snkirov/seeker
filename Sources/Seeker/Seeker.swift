//
//  Seeker.swift
//  Seeker
//
//  Created by Svilen Kirov on 6.06.22.
//

import Foundation
import Logging
import LoggingELK
import Metrics
import Prometheus

public struct Seeker {
    private static var tracehandler: TraceHandler?
    
    public static func loggerSetup(hostname: String = "localhost", port: Int = 5001) {
        LogstashLogHandler.setup(hostname: hostname, port: port)
    }
    
    public static func metricsSetup(serviceName: String, hostname: String = "localhost", port: Int? = 9091) {
        let myProm = PrometheusClient()
        MetricsSystem.bootstrap(PrometheusMetricsFactory(client: myProm))
        myProm.pushToGateway(host: hostname, port: port, jobName: serviceName)
        MetricsFactory.metrics = myProm
    }
    
    public static func metricsTeardown() {
        MetricsFactory.metrics?.tearDownPushToGateway()
        MetricsFactory.metrics = nil
    }
    
    public static func tracerSetup(serviceName: String, hostname: String = "localhost", port: UInt = 4317) {
        tracehandler = TraceHandler(serviceName: serviceName, hostname: hostname, port: port)
    }
    
    public static func tracerTeardown() {
        tracehandler?.shutdown()
        tracehandler = nil
    }
}
