//
//  LoggingELKTests.swift
//  
//
//  Created by Svilen Kirov on 22.08.22.
//

import XCTest
@testable import LoggingELK_Integration
@testable import Seeker

class LoggingELKTests: XCTestCase {
    func testSetupLoggingELKLogger() throws {
        Seeker.setupLoggingELKLogger(hostname: "sample")
        XCTAssertNoThrow(Seeker.logger, "The logger object should be initialised.")
    }
}
