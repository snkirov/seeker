//
//  PromMetricsWrapper.swift
//  
//
//  Created by Svilen Kirov on 6.08.22.
//

import Prometheus

/// Wraps the currently active metrics instance.
public struct PromMetricsWrapper {
    /// Defined as an optional, as to avoid instantiating it with a dummy value.
    public static var metrics: PrometheusClient?
}
