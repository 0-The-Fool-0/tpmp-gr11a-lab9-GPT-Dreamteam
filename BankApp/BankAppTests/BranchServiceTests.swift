//
//  BranchServiceTests.swift
//  BankAppTests
//

import Testing
@testable import BankApp

struct BranchServiceTests {
    @Test func fetchAllBranchesReturnsEmptyWithoutSeed() {
        let persistence = PersistenceController(inMemory: true)
        let service = BranchService(context: persistence.container.viewContext)

        #expect(service.fetchAllBranches().isEmpty)
    }

    @Test func fetchAllBranchesReturnsSeededOffices() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = BranchService(context: persistence.container.viewContext)

        let branches = service.fetchAllBranches()

        #expect(branches.count == 4)
        #expect(branches.allSatisfy { !$0.address.isEmpty })
    }
}
