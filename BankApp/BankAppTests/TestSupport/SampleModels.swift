//
//  SampleModels.swift
//  BankAppTests
//

import Foundation
@testable import BankApp

enum SampleModels {
    static func account(
        type: AccountType = .current,
        status: AccountStatus = .active,
        cardSubtype: CardSubtype? = nil,
        balance: Double = 10_000,
        footerKey: String? = nil,
        overdraftLimit: Double? = nil
    ) -> AccountItem {
        AccountItem(
            id: UUID(),
            accountNumber: "4081 7800 0000 0000 0001",
            type: type,
            cardSubtype: cardSubtype,
            status: status,
            titleKey: "account.current.title",
            subtitleKey: "account.current.subtitle",
            balance: balance,
            balanceLabelKey: "account.balance.remainder",
            footerKey: footerKey,
            overdraftLimit: overdraftLimit,
            sortOrder: 0
        )
    }

    static let minskCenter = BranchItem(
        id: UUID(),
        nameKey: "branch.minsk.center",
        address: "пр. Независимости, 56, Минск",
        latitude: 53.9045,
        longitude: 27.5615
    )

    static let brestMain = BranchItem(
        id: UUID(),
        nameKey: "branch.brest.main",
        address: "ул. Советская, 12, Брест",
        latitude: 52.0976,
        longitude: 23.7341
    )
}
