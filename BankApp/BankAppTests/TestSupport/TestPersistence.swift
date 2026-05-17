//
//  TestPersistence.swift
//  BankAppTests
//

import CoreData
@testable import BankApp

/// Fresh in-memory Core Data stack per call (shared model, isolated store).
enum TestPersistence {
    static func makeInMemory() -> PersistenceController {
        PersistenceController(inMemory: true)
    }

    static func makeSeeded() -> (PersistenceController, UserSession) {
        let controller = makeInMemory()
        let context = controller.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        guard let session = AuthService(context: context)
            .validate(login: "elena.kuznetsova", password: "demo1234") else {
            fatalError("Seed user must be available for tests")
        }
        return (controller, session)
    }
}
