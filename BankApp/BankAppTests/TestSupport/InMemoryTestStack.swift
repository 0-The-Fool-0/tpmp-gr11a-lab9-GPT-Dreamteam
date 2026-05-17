//
//  InMemoryTestStack.swift
//  BankAppTests
//

import CoreData
@testable import BankApp

enum InMemoryTestStack {
    static func makeSeeded() -> (PersistenceController, UserSession) {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let auth = AuthService(context: context)
        guard let session = auth.validate(login: "elena.kuznetsova", password: "demo1234") else {
            fatalError("Seed user must be available for tests")
        }
        return (persistence, session)
    }
}
