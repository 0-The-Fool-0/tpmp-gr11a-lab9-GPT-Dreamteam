//
//  PersistenceControllerTests.swift
//  BankAppTests
//

import Testing
@testable import BankApp

struct PersistenceControllerTests {
    @Test func inMemoryStoreLoadsSuccessfully() {
        let controller = PersistenceController(inMemory: true)
        #expect(controller.container.persistentStoreCoordinator.persistentStores.isEmpty == false)
    }

    @MainActor
    @Test func previewControllerHasSeededUser() {
        let context = PersistenceController.preview.container.viewContext
        let count = (try? context.count(for: User.fetchRequest())) ?? 0
        #expect(count >= 1)
    }
}
