//
//  LoginViewModelTests.swift
//  BankAppTests
//

import Testing
@testable import BankApp

@MainActor
struct LoginViewModelTests {
    @Test func signInWithEmptyFieldsSetsError() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: context),
            session: session
        )

        viewModel.signIn()

        #expect(viewModel.errorMessage != nil)
        #expect(!session.isAuthenticated)
    }

    @Test func signInWithInvalidCredentialsSetsError() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: context),
            session: session
        )
        viewModel.login = "elena.kuznetsova"
        viewModel.password = "wrong"

        viewModel.signIn()

        #expect(viewModel.errorMessage != nil)
        #expect(!session.isAuthenticated)
    }

    @Test func signInTrimsLoginWhitespace() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: context),
            session: session
        )
        viewModel.login = "  elena.kuznetsova  "
        viewModel.password = "demo1234"

        viewModel.signIn()

        #expect(session.isAuthenticated)
    }

    @Test func faceIDTappedShowsAlert() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        let viewModel = LoginViewModel(
            authService: AuthService(context: context),
            session: SessionStore()
        )

        viewModel.faceIDTapped()

        #expect(viewModel.showFaceIDAlert)
    }

    @Test func signInWithValidCredentialsAuthenticatesUser() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        DataSeedService(context: context).seedIfNeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: context),
            session: session
        )
        viewModel.login = "elena.kuznetsova"
        viewModel.password = "demo1234"

        viewModel.signIn()

        #expect(viewModel.errorMessage == nil)
        #expect(session.isAuthenticated)
        #expect(session.currentUser?.displayName == "Елена")
    }
}
