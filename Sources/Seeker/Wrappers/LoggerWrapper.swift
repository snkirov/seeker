//
//  LoggerWrapper.swift
//  Seeker
//
//  Created by Svilen Kirov on 5.07.22.
//

import Foundation
import Logging

/// Wraps the currently active logger instance.
struct LoggerWrapper {
    /// Defined as an optional, as to avoid instantiating it with a dummy value.
    static var logger: Logger?
}
