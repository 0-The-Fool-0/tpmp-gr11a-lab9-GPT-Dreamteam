//
//  LoginViewModel.swift
//  BankApp
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var login = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var showFaceIDAlert = false

    private let authService: AuthService
    private let session: SessionStore

    init(authService: AuthService, session: SessionStore) {
        self.authService = authService
        self.session = session
    }

    func signIn() {
        errorMessage = nil
        let trimmedLogin = login.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedLogin.isEmpty, !password.isEmpty else {
            errorMessage = String(localized: "login.error.empty")
            return
        }
        if let user = authService.validate(login: trimmedLogin, password: password) {
            session.login(user)
        } else {
            errorMessage = String(localized: "login.error.invalid")
        }
    }

    func faceIDTapped() {
        showFaceIDAlert = true
    }
}
