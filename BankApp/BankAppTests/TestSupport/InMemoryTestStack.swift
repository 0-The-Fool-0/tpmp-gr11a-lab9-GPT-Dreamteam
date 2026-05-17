//
//  InMemoryTestStack.swift
//  BankAppTests
//

import CoreData
@testable import BankApp

enum InMemoryTestStack {
    static func makeSeeded() -> (PersistenceController, UserSession) {
        TestPersistence.makeSeeded()
    }
}
