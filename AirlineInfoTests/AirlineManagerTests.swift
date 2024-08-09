//
//  AirlineManagerTests.swift
//  AirlineInfoTests
//
//  Created by Anas Salah on 09/08/2024.
//

import XCTest
@testable import AirlineInfo

class AirlineManagerTests: XCTestCase {
    var airlineManager: AirlineManager!

    override func setUp() {
        super.setUp()
        airlineManager = AirlineManager()
    }

    override func tearDown() {
        airlineManager = nil
        super.tearDown()
    }

    func testFetchAirlines() {
        // This test assumes that you have a valid URL and a running server
        let expectation = self.expectation(description: "Fetch airlines")

        airlineManager.fetchAirlines { result in
            switch result {
            case .success(let airlines):
                // Assert that airlines are loaded
                XCTAssertFalse(airlines.isEmpty, "Airlines should not be empty")
                self.airlineManager.allAirlines = airlines
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchFavorites() {
        // Add a favorite to Core Data
        CoreDataHelper.shared.addFavorite(name: "Test Airline", site: "test.com")

        // Act
        airlineManager.fetchFavorites()

        // Assert
        XCTAssertTrue(airlineManager.favorites.contains("Test Airline"), "Favorites should include 'Test Airline'")
    }

    func testToggleFavorite() {
        let airlineName = "Test Airline"

        // Act: Add favorite
        airlineManager.toggleFavorite(for: airlineName)
        XCTAssertTrue(airlineManager.favorites.contains(airlineName), "Favorite should be added")

        // Act: Remove favorite
        airlineManager.toggleFavorite(for: airlineName)
        XCTAssertFalse(airlineManager.favorites.contains(airlineName), "Favorite should be removed")
    }
}

