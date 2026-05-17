//
//  LoginViewModelTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

@MainActor
struct LoginViewModelTests {
    @Test func signInWithEmptyFieldsSetsError() {
        let (persistence, _) = TestPersistence.makeSeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: persistence.container.viewContext),
            session: session
        )

        viewModel.signIn()

        #expect(viewModel.errorMessage != nil)
        #expect(!session.isAuthenticated)
    }

    @Test func signInWithInvalidCredentialsSetsError() {
        let (persistence, _) = TestPersistence.makeSeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: persistence.container.viewContext),
            session: session
        )
        viewModel.login = "elena.kuznetsova"
        viewModel.password = "wrong"

        viewModel.signIn()

        #expect(viewModel.errorMessage != nil)
        #expect(!session.isAuthenticated)
    }

    @Test func signInTrimsLoginWhitespace() {
        let (persistence, _) = TestPersistence.makeSeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: persistence.container.viewContext),
            session: session
        )
        viewModel.login = "  elena.kuznetsova  "
        viewModel.password = "demo1234"

        viewModel.signIn()

        #expect(session.isAuthenticated)
    }

    @Test func faceIDTappedShowsAlert() {
        let persistence = TestPersistence.makeInMemory()
        let viewModel = LoginViewModel(
            authService: AuthService(context: persistence.container.viewContext),
            session: SessionStore()
        )

        viewModel.faceIDTapped()

        #expect(viewModel.showFaceIDAlert)
    }

    @Test func signInWithValidCredentialsAuthenticatesUser() {
        let (persistence, _) = TestPersistence.makeSeeded()
        let session = SessionStore()
        let viewModel = LoginViewModel(
            authService: AuthService(context: persistence.container.viewContext),
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
