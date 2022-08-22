//
//  DefaultConfigurationTests.swift
//  
//
//  Created by Svilen Kirov on 22.08.22.
//

import XCTest
@testable import Seeker
@testable import Default_Configuration

class DefaultConfigurationTests: XCTestCase {

    func testSetupDefaultConfiguration() throws {
        Seeker.setupDefaultConfiguration(host: "example")
        XCTAssertNoThrow(Seeker.logger, "The logger object should be initialised.")
        XCTAssertNoThrow(Seeker.metrics, "The metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.promMetrics, "The prom metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.tracer, "The tracer object should be initialised.")
    }
/*
    func testSetupDefaultConfigurationLongerMethod() throws {
        Seeker.setupDefaultConfiguration(loggingHost: "example1", metricsHost: "example2", tracingHost: "example3")
        XCTAssertNoThrow(Seeker.logger, "The logger object should be initialised.")
        XCTAssertNoThrow(Seeker.metrics, "The metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.promMetrics, "The prom metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.tracer, "The tracer object should be initialised.")
    }
    
    func testSetupDefaultConfigurationLongestMethod() throws {
        Seeker.setupDefaultConfiguration(loggingHost: "example1", loggingPort: 5001, metricsHost: "example2", metricsPort: 9001, tracingHost: "example3", tracingPort: 9190)
        XCTAssertNoThrow(Seeker.logger, "The logger object should be initialised.")
        XCTAssertNoThrow(Seeker.metrics, "The metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.promMetrics, "The prom metrics object should be initialised.")
        XCTAssertNoThrow(Seeker.tracer, "The tracer object should be initialised.")
    }
*/
}
