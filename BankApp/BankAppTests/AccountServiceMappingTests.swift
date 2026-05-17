//
//  AccountServiceMappingTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct AccountServiceMappingTests {
    @Test func fetchVisibleAccountsSkipsInvalidRecords() throws {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let context = persistence.container.viewContext
        let userRequest = User.fetchRequest()
        userRequest.predicate = NSPredicate(format: "id == %@", session.id as NSUUID)
        let user = try #require(try context.fetch(userRequest).first)

        let invalid = Account(context: context)
        invalid.id = UUID()
        invalid.user = user
        invalid.accountNumber = "0000"
        invalid.type = "unknown_type"
        invalid.status = AccountStatus.active.rawValue
        invalid.titleKey = "account.current.title"
        invalid.subtitleKey = "account.current.subtitle"
        invalid.balanceLabelKey = "account.balance.remainder"
        invalid.balance = 1
        invalid.sortOrder = 50
        try context.save()

        let service = AccountService(context: context)
        let accounts = service.fetchVisibleAccounts(for: session.id)

        #expect(accounts.count == 5)
        #expect(accounts.allSatisfy { $0.type != .current || $0.accountNumber != "0000" })
    }
}
