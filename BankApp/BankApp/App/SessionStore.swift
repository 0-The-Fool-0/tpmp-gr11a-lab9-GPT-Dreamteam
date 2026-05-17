//
//  SessionStore.swift
//  BankApp
//

import Foundation
import Combine

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var currentUser: UserSession?

    var isAuthenticated: Bool { currentUser != nil }

    func login(_ user: UserSession) {
        currentUser = user
    }

    func logout() {
        currentUser = nil
    }
}
