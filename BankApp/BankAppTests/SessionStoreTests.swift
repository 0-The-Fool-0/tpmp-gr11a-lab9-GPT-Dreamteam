//
//  SessionStoreTests.swift
//  BankAppTests
//

import Testing
@testable import BankApp

@MainActor
struct SessionStoreTests {
    @Test func loginAndLogoutUpdateAuthenticationState() {
        let store = SessionStore()
        let user = UserSession(id: UUID(), login: "demo", displayName: "Demo")

        store.login(user)

        #expect(store.isAuthenticated)
        #expect(store.currentUser == user)

        store.logout()

        #expect(!store.isAuthenticated)
        #expect(store.currentUser == nil)
    }
}
