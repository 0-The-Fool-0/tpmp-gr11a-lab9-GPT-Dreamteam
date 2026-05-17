//
//  AuthServiceTests.swift
//  BankAppTests
//

import Testing
@testable import BankApp

struct AuthServiceTests {
    @Test func validateReturnsSessionForDemoUser() {
        let (persistence, expected) = InMemoryTestStack.makeSeeded()
        let auth = AuthService(context: persistence.container.viewContext)

        let result = auth.validate(login: "elena.kuznetsova", password: "demo1234")

        #expect(result == expected)
    }

    @Test func validateReturnsNilForUnknownLogin() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let auth = AuthService(context: context)

        #expect(auth.validate(login: "nobody", password: "demo1234") == nil)
    }

    @Test func validateReturnsNilForWrongPassword() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let auth = AuthService(context: context)

        #expect(auth.validate(login: "elena.kuznetsova", password: "wrong") == nil)
    }

}
