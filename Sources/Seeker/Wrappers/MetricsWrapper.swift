//
//  MetricsWrapper.swift
//  Seeker
//
//  Created by Svilen Kirov on 5.07.22.
//

import Foundation
import Prometheus

/// Wraps the currently active metrics instance.
struct MetricsWrapper {
    /// Defined as an optional, as to avoid instantiating it with a dummy value.
    static var metrics: PrometheusClient?
}
