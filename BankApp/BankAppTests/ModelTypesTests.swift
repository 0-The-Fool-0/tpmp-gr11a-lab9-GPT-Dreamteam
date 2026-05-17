//
//  ModelTypesTests.swift
//  BankAppTests
//

import Foundation
import Testing
@testable import BankApp

struct ModelTypesTests {
    @Test func userSessionEquality() {
        let id = UUID()
        let a = UserSession(id: id, login: "a", displayName: "A")
        let b = UserSession(id: id, login: "a", displayName: "A")
        #expect(a == b)
    }

    @Test func branchItemNameIsLocalized() {
        let branch = SampleModels.minskCenter
        #expect(!branch.name.isEmpty)
        #expect(branch.name.contains("Минск") || !branch.address.isEmpty)
    }

    @Test func rateItemIdentityUsesCurrencyCode() {
        let rate = RateItem(id: "USD", currencyCode: "USD", buyRate: 1, updatedAt: Date())
        #expect(rate.id == "USD")
    }

    @Test func accountSummaryStoresValues() {
        let date = Date()
        let summary = AccountSummary(totalAvailable: 100, updatedAt: date)
        #expect(summary.totalAvailable == 100)
        #expect(summary.updatedAt == date)
    }

    @Test func accountEnumsRawValues() {
        #expect(AccountType.current.rawValue == "current")
        #expect(CardSubtype.payroll.rawValue == "payroll")
        #expect(AccountStatus.closed.rawValue == "closed")
    }
}
