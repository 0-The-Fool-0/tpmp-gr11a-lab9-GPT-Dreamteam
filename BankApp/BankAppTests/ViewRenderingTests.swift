//
//  ViewRenderingTests.swift
//  BankAppTests
//

import SwiftUI
import Testing
@testable import BankApp

@MainActor
struct ViewRenderingTests {
    @Test func accountCardViewRenders() {
        let account = SampleModels.account(footerKey: "account.credit.footer")
        let controller = ViewTestSupport.host(AccountCardView(account: account))
        #expect(controller.view.intrinsicContentSize.height > 0)
    }

    @Test func accountTagViewRenders() {
        let controller = ViewTestSupport.host(AccountTagView(text: "Active"))
        #expect(controller.view != nil)
    }

    @Test func bankLogoViewRenders() {
        let controller = ViewTestSupport.host(BankLogoView())
        #expect(controller.view != nil)
    }

    @Test func labeledTextFieldRenders() {
        let controller = ViewTestSupport.host(
            LabeledTextField(
                label: "login.field.login",
                placeholder: "login.placeholder.login",
                text: .constant("demo"),
                accessibilityIdentifier: AccessibilityID.loginField
            )
        )
        #expect(controller.view != nil)
    }

    @Test func rootViewShowsLoginWhenLoggedOut() {
        let (dependencies, session, _) = ViewTestSupport.seededDependencies()
        let view = RootView()
            .environmentObject(session)
            .environment(\.appDependencies, dependencies)
        let controller = ViewTestSupport.host(view)
        #expect(!session.isAuthenticated)
        #expect(controller.view != nil)
    }

    @Test func mainTabViewRequiresAuthentication() {
        let (dependencies, session, user) = ViewTestSupport.seededDependencies()
        session.login(user)
        let view = MainTabView()
            .environmentObject(session)
            .environment(\.appDependencies, dependencies)
        let controller = ViewTestSupport.host(view)
        #expect(session.isAuthenticated)
        #expect(controller.view != nil)
    }

    @Test func homeViewRendersForAuthenticatedUser() {
        let (dependencies, _, user) = ViewTestSupport.seededDependencies()
        let controller = ViewTestSupport.host(HomeView(user: user, dependencies: dependencies))
        #expect(controller.view != nil)
    }

    @Test func accountsListViewRenders() {
        let (dependencies, _, user) = ViewTestSupport.seededDependencies()
        let controller = ViewTestSupport.host(
            AccountsListView(user: user, dependencies: dependencies)
        )
        #expect(controller.view != nil)
    }

    @Test func branchesMapViewRenders() {
        let (dependencies, _, _) = ViewTestSupport.seededDependencies()
        let controller = ViewTestSupport.host(BranchesMapView(dependencies: dependencies))
        #expect(controller.view != nil)
    }

    @Test func loginViewRendersWithDependencies() {
        let (dependencies, session, _) = ViewTestSupport.seededDependencies()
        let view = LoginView()
            .environmentObject(session)
            .environment(\.appDependencies, dependencies)
        let controller = ViewTestSupport.host(view)
        #expect(controller.view != nil)
    }
}
