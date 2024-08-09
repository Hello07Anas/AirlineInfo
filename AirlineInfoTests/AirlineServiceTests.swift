//
//  AirlineServiceTests.swift
//  AirlineInfoTests
//
//  Created by Anas Salah on 09/08/2024.
//

import XCTest
@testable import AirlineInfo

class AirlineServiceTests: XCTestCase {

    func testFetchAirlinesSuccess() {
        // Arrange
        let airlineService = AirlineService()
        let expectation = self.expectation(description: "Fetch airlines")

        // Act
        airlineService.fetchAirlines { airlines, error in
            // Assert
            XCTAssertNil(error, "Error should be nil")
            XCTAssertNotNil(airlines, "Airlines should not be nil")
            XCTAssertTrue(airlines?.count ?? 0 > 0, "Airlines array should not be empty")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchAirlinesFailure() {
        // Arrange
        let airlineService = AirlineService()
        let expectation = self.expectation(description: "Fetch airlines")

        // Simulate a failure by providing an invalid URL in the `AirlineService` class
        let originalBaseUrl = K.Base_Url // TODO: Go to Constants and un commit line of testing
        K.Base_Url = "invalid_url"
        
        // Act
        airlineService.fetchAirlines { airlines, error in
            // Assert
            XCTAssertNil(airlines, "Airlines should be nil")
            XCTAssertNotNil(error, "Error should not be nil")
            XCTAssertEqual((error as NSError?)?.domain, NSURLErrorDomain, "Error domain should be NSURLErrorDomain")
            K.Base_Url = originalBaseUrl // Restore the original URL
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
