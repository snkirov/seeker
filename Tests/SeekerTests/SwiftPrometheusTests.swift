//
//  SwiftPrometheusTests.swift
//  
//
//  Created by Svilen Kirov on 22.08.22.
//

import XCTest
@testable import Seeker
@testable import SwiftPrometheus_Integration

class SwiftPrometheusTests: XCTestCase {

    func testSetupPrometheusMetrics() throws {
        Seeker.setupSwiftPrometheusMetrics(hostname: "example")
        XCTAssertNoThrow(Seeker.metrics, "The metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.promMetrics, "The prom metrics object should be initialised.")
    }
}
