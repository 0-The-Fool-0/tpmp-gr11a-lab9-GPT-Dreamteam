//
//  AccountServiceTests.swift
//  BankAppTests
//

import CoreData
import Foundation
import Testing
@testable import BankApp

struct AccountServiceTests {
    @Test func fetchVisibleAccountsExcludesClosed() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let service = AccountService(context: persistence.container.viewContext)

        let accounts = service.fetchVisibleAccounts(for: session.id)

        #expect(accounts.count == 5)
        #expect(accounts.allSatisfy { $0.status != .closed })
    }

    @Test func fetchSummarySumsActiveBalances() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let service = AccountService(context: persistence.container.viewContext)

        let summary = service.fetchSummary(for: session.id)

        // 242_900 + 740_000 + (-180_000) + 115_520 = 918_420
        #expect(summary.totalAvailable == 918_420)
    }

    @Test func fetchSummaryForUnknownUserReturnsZero() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = AccountService(context: persistence.container.viewContext)

        let summary = service.fetchSummary(for: UUID())

        #expect(summary.totalAvailable == 0)
    }

    @Test func fetchVisibleAccountsForUnknownUserIsEmpty() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = AccountService(context: persistence.container.viewContext)

        #expect(service.fetchVisibleAccounts(for: UUID()).isEmpty)
    }

    @Test func activeSavingsUsesPositiveBalanceOnly() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let service = AccountService(context: persistence.container.viewContext)
        let savings = service.fetchVisibleAccounts(for: session.id).first { $0.type == .savings }

        #expect(savings?.balance == 740_000)
    }

    @Test func fetchVisibleAccountsSortedBySortOrder() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let service = AccountService(context: persistence.container.viewContext)

        let orders = service.fetchVisibleAccounts(for: session.id).map(\.sortOrder)

        #expect(orders == orders.sorted())
    }
}
