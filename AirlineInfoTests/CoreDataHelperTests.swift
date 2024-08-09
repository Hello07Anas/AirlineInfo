//
//  CoreDataHelperTests.swift
//  AirlineInfoTests
//
//  Created by Anas Salah on 09/08/2024.
//

import XCTest
import CoreData
@testable import AirlineInfo

class CoreDataHelperTests: XCTestCase {
    var coreDataHelper: CoreDataHelper!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        coreDataHelper = CoreDataHelper.shared
        
        let inMemoryContainer = NSPersistentContainer(name: "AirlineInfo")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        inMemoryContainer.persistentStoreDescriptions = [description]
        inMemoryContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        
        coreDataHelper.persistentContainer = inMemoryContainer
        context = inMemoryContainer.viewContext
    }

    override func tearDown() {
        coreDataHelper = nil
        context = nil
        super.tearDown()
    }

    func testAddFavorite() {
        // Arrange
        let name = "Test Airline"
        let site = "test.com"
        
        // Act
        coreDataHelper.addFavorite(name: name, site: site)
        
        // Assert
        let fetchRequest: NSFetchRequest<Airline> = Airline.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        let names = results?.compactMap { $0.name }
        XCTAssertTrue(names?.contains(name) == true, "Favorite should be added")
    }

    func testRemoveFavorite() {
        // Arrange
        let name = "Test Airline"
        let site = "test.com"
        coreDataHelper.addFavorite(name: name, site: site)
        
        // Act
        coreDataHelper.removeFavorite(name: name)
        
        // Assert
        let fetchRequest: NSFetchRequest<Airline> = Airline.fetchRequest()
        let results = try? context.fetch(fetchRequest)
        let names = results?.compactMap { $0.name }
        XCTAssertFalse(names?.contains(name) == true, "Favorite should be removed")
    }

    func testFetchFavorites() {
        // Arrange
        let name1 = "Airline 1"
        let name2 = "Airline 2"
        coreDataHelper.addFavorite(name: name1, site: "site1.com")
        coreDataHelper.addFavorite(name: name2, site: "site2.com")
        
        // Act
        let favorites = coreDataHelper.fetchFavorites()
        
        // Assert
        XCTAssertTrue(favorites.contains(name1), "Favorites should include Airline 1")
        XCTAssertTrue(favorites.contains(name2), "Favorites should include Airline 2")
    }
}
