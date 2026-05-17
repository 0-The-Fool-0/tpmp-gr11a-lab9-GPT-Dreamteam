//
//  AccountItemTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct AccountItemTests {
    @Test func localizedPropertiesAreNonEmpty() {
        let item = SampleModels.account(footerKey: "account.credit.footer")

        #expect(!item.title.isEmpty)
        #expect(!item.subtitle.isEmpty)
        #expect(!item.balanceLabel.isEmpty)
        #expect(item.footer != nil)
    }

    @Test func footerIsNilWithoutKey() {
        let item = SampleModels.account(footerKey: nil)
        #expect(item.footer == nil)
    }

    @Test(arguments: AccountType.allCases)
    func typeTagForEachAccountType(_ type: AccountType) {
        let item = SampleModels.account(type: type)
        #expect(!item.typeTag.isEmpty)
    }

    @Test(arguments: [AccountStatus.active, .blocked, .closed])
    func statusTagForEachStatus(_ status: AccountStatus) {
        let item = SampleModels.account(status: status)
        #expect(!item.statusTag.isEmpty)
    }

    @Test func seededPayrollCardHasOverdraft() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let accounts = AccountService(context: persistence.container.viewContext)
            .fetchVisibleAccounts(for: session.id)
        let payroll = accounts.first { $0.cardSubtype == .payroll }

        #expect(payroll?.overdraftLimit == 50_000)
        #expect(payroll?.footer != nil)
    }

    @Test func seededAccountsIncludeBlockedAndCredit() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let accounts = AccountService(context: persistence.container.viewContext)
            .fetchVisibleAccounts(for: session.id)

        #expect(accounts.contains { $0.status == .blocked })
        #expect(accounts.contains { $0.type == .credit && $0.balance < 0 })
    }
}
