//
//  AccountService.swift
//  BankApp
//

import CoreData
import Foundation

final class AccountService {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchVisibleAccounts(for userID: UUID) -> [AccountItem] {
        var items: [AccountItem] = []
        context.performAndWait {
            guard let user = fetchUser(id: userID) else { return }
            let request = Account.fetchRequest()
            request.predicate = NSPredicate(
                format: "user == %@ AND status != %@",
                user,
                AccountStatus.closed.rawValue
            )
            request.sortDescriptors = [NSSortDescriptor(key: "sortOrder", ascending: true)]
            let accounts = (try? context.fetch(request)) ?? []
            items = accounts.compactMap(mapAccount)
        }
        return items
    }

    func fetchSummary(for userID: UUID) -> AccountSummary {
        var summary = AccountSummary(totalAvailable: 0, updatedAt: Date())
        context.performAndWait {
            guard let user = fetchUser(id: userID) else { return }
            let request = Account.fetchRequest()
            request.predicate = NSPredicate(
                format: "user == %@ AND status == %@",
                user,
                AccountStatus.active.rawValue
            )
            let accounts = (try? context.fetch(request)) ?? []
            let total = accounts.reduce(0.0) { partial, account in
                let type = AccountType(rawValue: account.type ?? "") ?? .current
                switch type {
                case .credit:
                    return partial + account.balance
                default:
                    return partial + max(account.balance, 0)
                }
            }
            summary = AccountSummary(totalAvailable: total, updatedAt: Date())
        }
        return summary
    }

    private func fetchUser(id: UUID) -> User? {
        let request = User.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        return try? context.fetch(request).first
    }

    private func mapAccount(_ account: Account) -> AccountItem? {
        guard let id = account.id,
              let type = AccountType(rawValue: account.type ?? ""),
              let status = AccountStatus(rawValue: account.status ?? "") else { return nil }
        let cardSubtype = account.cardSubtype.flatMap { CardSubtype(rawValue: $0) }
        let overdraft: Double? = (cardSubtype == .payroll && account.overdraftLimit > 0)
            ? account.overdraftLimit
            : nil
        return AccountItem(
            id: id,
            accountNumber: account.accountNumber ?? "",
            type: type,
            cardSubtype: cardSubtype,
            status: status,
            titleKey: account.titleKey ?? "",
            subtitleKey: account.subtitleKey ?? "",
            balance: account.balance,
            balanceLabelKey: account.balanceLabelKey ?? "",
            footerKey: account.footerKey,
            overdraftLimit: overdraft,
            sortOrder: Int(account.sortOrder)
        )
    }
}
