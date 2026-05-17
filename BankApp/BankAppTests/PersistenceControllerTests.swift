//
//  PersistenceControllerTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct PersistenceControllerTests {
    @Test func inMemoryStoreLoadsSuccessfully() {
        let controller = TestPersistence.makeInMemory()
        #expect(controller.container.persistentStoreCoordinator.persistentStores.isEmpty == false)
    }

    @Test func seededStoreContainsDemoUser() {
        let (controller, _) = TestPersistence.makeSeeded()
        let context = controller.container.viewContext
        let count = (try? context.count(for: User.fetchRequest())) ?? 0
        #expect(count >= 1)
    }
}
