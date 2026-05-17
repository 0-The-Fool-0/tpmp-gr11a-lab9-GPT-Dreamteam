//
//  AuthServiceTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct AuthServiceTests {
    @Test func validateReturnsSessionForDemoUser() {
        let (persistence, expected) = TestPersistence.makeSeeded()
        let auth = AuthService(context: persistence.container.viewContext)

        let result = auth.validate(login: "elena.kuznetsova", password: "demo1234")

        #expect(result == expected)
    }

    @Test func validateReturnsNilForUnknownLogin() {
        let (persistence, _) = TestPersistence.makeSeeded()
        let auth = AuthService(context: persistence.container.viewContext)

        #expect(auth.validate(login: "nobody", password: "demo1234") == nil)
    }

    @Test func validateReturnsNilForWrongPassword() {
        let (persistence, _) = TestPersistence.makeSeeded()
        let auth = AuthService(context: persistence.container.viewContext)

        #expect(auth.validate(login: "elena.kuznetsova", password: "wrong") == nil)
    }

}
