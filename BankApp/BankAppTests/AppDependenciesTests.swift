//
//  AppDependenciesTests.swift
//  BankAppTests
//

import Foundation
import Testing
@testable import BankApp

@MainActor
struct AppDependenciesTests {
    @Test func initWiresServicesAndSeedsOnFirstLaunch() {
        let dependencies = AppDependencies(persistence: TestPersistence.makeInMemory())

        #expect(dependencies.authService.validate(login: "", password: "") == nil)
        #expect(dependencies.accountService.fetchVisibleAccounts(for: UUID()).isEmpty)
        #expect(dependencies.exchangeRateService.fetchRates().count == 2)
        #expect(dependencies.branchService.fetchAllBranches().count == 4)
    }

    @Test func seededDependenciesExposeDemoUser() {
        let (dependencies, _, session) = ViewTestSupport.seededDependencies()
        let auth = dependencies.authService.validate(login: "elena.kuznetsova", password: "demo1234")

        #expect(auth?.id == session.id)
        #expect(dependencies.branchService.fetchAllBranches().count == 4)
    }

    @Test func accessibilityIdentifiersAreStable() {
        #expect(!AccessibilityID.loginField.isEmpty)
        #expect(!AccessibilityID.homeSummaryAmount.isEmpty)
        #expect(!AccessibilityID.accountCard.isEmpty)
    }
}
