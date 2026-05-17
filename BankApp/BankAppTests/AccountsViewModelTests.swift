//
//  AccountsViewModelTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

@MainActor
struct AccountsViewModelTests {
    @Test func reloadLoadsVisibleAccounts() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let viewModel = AccountsViewModel(
            userID: session.id,
            accountService: AccountService(context: persistence.container.viewContext)
        )

        #expect(viewModel.accounts.count == 5)
    }

    @Test func reloadUpdatesAccountsList() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let viewModel = AccountsViewModel(
            userID: session.id,
            accountService: AccountService(context: persistence.container.viewContext)
        )
        viewModel.reload()
        #expect(viewModel.accounts.count == 5)
    }
}
