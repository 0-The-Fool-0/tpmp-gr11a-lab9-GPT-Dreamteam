//
//  DataSeedService.swift
//  BankApp
//

import CoreData
import Foundation

final class DataSeedService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func seedIfNeeded() {
        context.performAndWait {
            let request = User.fetchRequest()
            request.fetchLimit = 1
            let count = (try? context.count(for: request)) ?? 0
            guard count == 0 else { return }
            seed()
        }
    }

    private func seed() {
        let user = User(context: context)
        user.id = UUID()
        user.login = "elena.kuznetsova"
        user.password = "demo1234"
        user.displayName = "Елена"

        addAccount(
            user: user,
            number: "4081 7800 1023 4567 8901",
            type: .current,
            status: .active,
            titleKey: "account.current.title",
            subtitleKey: "account.current.subtitle",
            balance: 242_900,
            balanceLabelKey: "account.balance.remainder",
            sortOrder: 0
        )

        addAccount(
            user: user,
            number: "4230 1500 9876 5432 1000",
            type: .savings,
            status: .active,
            titleKey: "account.savings.title",
            subtitleKey: "account.savings.subtitle",
            balance: 740_000,
            balanceLabelKey: "account.balance.capitalization",
            footerKey: nil,
            sortOrder: 1
        )

        addAccount(
            user: user,
            number: "4555 8800 1122 3344 5566",
            type: .credit,
            status: .active,
            titleKey: "account.credit.title",
            subtitleKey: "account.credit.subtitle",
            balance: -180_000,
            balanceLabelKey: "account.balance.debt",
            footerKey: "account.credit.footer",
            sortOrder: 2
        )

        addAccount(
            user: user,
            number: "4081 7810 5566 7788 9900",
            type: .card,
            cardSubtype: .payroll,
            status: .active,
            titleKey: "account.card.payroll.title",
            subtitleKey: "account.card.payroll.subtitle",
            balance: 115_520,
            balanceLabelKey: "account.balance.remainder",
            footerKey: "account.card.payroll.footer",
            overdraftLimit: 50_000,
            sortOrder: 3
        )

        addAccount(
            user: user,
            number: "4081 7810 0011 2233 4455",
            type: .card,
            cardSubtype: .savings,
            status: .blocked,
            titleKey: "account.card.savings.title",
            subtitleKey: "account.card.savings.subtitle",
            balance: 12_000,
            balanceLabelKey: "account.balance.remainder",
            sortOrder: 4
        )

        addAccount(
            user: user,
            number: "4081 7800 9999 0000 1111",
            type: .current,
            status: .closed,
            titleKey: "account.current.title",
            subtitleKey: "account.current.subtitle",
            balance: 0,
            balanceLabelKey: "account.balance.remainder",
            sortOrder: 99
        )

        let usd = ExchangeRate(context: context)
        usd.currencyCode = "USD"
        usd.buyRate = 92.40
        usd.updatedAt = seededUpdateTime(hour: 9, minute: 38)

        let eur = ExchangeRate(context: context)
        eur.currencyCode = "EUR"
        eur.buyRate = 100.15
        eur.updatedAt = seededUpdateTime(hour: 9, minute: 38)

        addBranch(nameKey: "branch.minsk.center", address: "пр. Независимости, 56, Минск", lat: 53.9045, lon: 27.5615)
        addBranch(nameKey: "branch.minsk.south", address: "ул. Притыцкого, 158, Минск", lat: 53.8642, lon: 27.4768)
        addBranch(nameKey: "branch.minsk.east", address: "пр. Партизанский, 150, Минск", lat: 53.8598, lon: 27.6741)
        addBranch(nameKey: "branch.brest.main", address: "ул. Советская, 12, Брест", lat: 52.0976, lon: 23.7341)

        try? context.save()
    }

    private func addAccount(
        user: User,
        number: String,
        type: AccountType,
        cardSubtype: CardSubtype? = nil,
        status: AccountStatus,
        titleKey: String,
        subtitleKey: String,
        balance: Double,
        balanceLabelKey: String,
        footerKey: String? = nil,
        overdraftLimit: Double? = nil,
        sortOrder: Int
    ) {
        let account = Account(context: context)
        account.id = UUID()
        account.accountNumber = number
        account.type = type.rawValue
        account.cardSubtype = cardSubtype?.rawValue
        account.status = status.rawValue
        account.titleKey = titleKey
        account.subtitleKey = subtitleKey
        account.balance = balance
        account.balanceLabelKey = balanceLabelKey
        account.footerKey = footerKey
        account.overdraftLimit = overdraftLimit ?? 0
        if overdraftLimit == nil {
            account.overdraftLimit = 0
        }
        account.sortOrder = Int16(sortOrder)
        account.user = user
    }

    private func addBranch(nameKey: String, address: String, lat: Double, lon: Double) {
        let branch = Branch(context: context)
        branch.id = UUID()
        branch.nameKey = nameKey
        branch.address = address
        branch.latitude = lat
        branch.longitude = lon
    }

    private func seededUpdateTime(hour: Int, minute: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components) ?? Date()
    }
}
