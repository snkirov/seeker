//
//  TracerWrapper.swift
//  
//
//  Created by Svilen Kirov on 18.07.22.
//

import Foundation
import Tracing

/// Wraps the currently active tracer instance.
struct TracerWrapper {
    /// Defined as an optional, as to avoid instantiating it with a dummy value.
    static var tracer: Tracer?
}
