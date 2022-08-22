//
//  OpenTelemetryTests.swift
//  
//
//  Created by Svilen Kirov on 22.08.22.
//

import XCTest
@testable import Seeker
@testable import OpenTelemetry_Integration

class OpenTelemetryTests: XCTestCase {

    func testSetupPrometheusMetrics() throws {
        Seeker.setupOpenTelemetryTracer(hostname: "example")
        XCTAssertNoThrow(Seeker.tracer, "The tracer object should be initialised.")
    }

}
