//
//  DataSeedServiceTests.swift
//  BankAppTests
//

import CoreData
import Testing
@testable import BankApp

struct DataSeedServiceTests {
    @Test func seedIfNeededPopulatesDatabaseOnce() throws {
        let context = TestPersistence.makeInMemory().container.viewContext
        let seeder = DataSeedService(context: context)

        seeder.seedIfNeeded()
        seeder.seedIfNeeded()

        let userCount = try context.count(for: User.fetchRequest())
        let accountCount = try context.count(for: Account.fetchRequest())
        let branchCount = try context.count(for: Branch.fetchRequest())
        let rateCount = try context.count(for: ExchangeRate.fetchRequest())

        #expect(userCount == 1)
        #expect(accountCount == 6)
        #expect(branchCount == 4)
        #expect(rateCount == 2)
    }
}
