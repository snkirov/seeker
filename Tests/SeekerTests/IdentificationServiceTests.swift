//
//  IdentificationServiceTests.swift
//  
//
//  Created by Svilen Kirov on 22.08.22.
//

import XCTest
@testable import Seeker

class IdentificationServiceTests: XCTestCase {

    func testGeneratesSameIdentifier() throws {
        let idService = DefaultIdentificationService()
        let firstIdentifier = idService.getObservabilityIdentifier()
        let secondIdentifier = idService.getObservabilityIdentifier()
        let thirdIdentifier = idService.getObservabilityIdentifier()
        XCTAssertEqual(firstIdentifier, secondIdentifier, "All identifiers must be equal")
        XCTAssertEqual(firstIdentifier, thirdIdentifier, "All identifiers must be equal")
    }
}
