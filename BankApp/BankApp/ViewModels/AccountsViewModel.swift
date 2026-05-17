//
//  AccountsViewModel.swift
//  BankApp
//

import Foundation
import Combine

@MainActor
final class AccountsViewModel: ObservableObject {
    @Published private(set) var accounts: [AccountItem] = []

    private let accountService: AccountService
    private let userID: UUID

    init(userID: UUID, accountService: AccountService) {
        self.userID = userID
        self.accountService = accountService
        reload()
    }

    func reload() {
        accounts = accountService.fetchVisibleAccounts(for: userID)
    }
}
