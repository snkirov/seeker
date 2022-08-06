//
//  MetricsWrapper.swift
//  Seeker
//
//  Created by Svilen Kirov on 5.07.22.
//

import Prometheus

/// Wraps the currently active metrics instance.
public struct MetricsWrapper {
    /// Defined as an optional, as to avoid instantiating it with a dummy value.
    public static var metrics: PrometheusClient?
}
