//
//  ExchangeRateServiceTests.swift
//  BankAppTests
//

import Testing
@testable import BankApp

struct ExchangeRateServiceTests {
    @Test func fetchRatesReturnsEmptyWhenDatabaseIsEmpty() {
        let persistence = PersistenceController(inMemory: true)
        let service = ExchangeRateService(context: persistence.container.viewContext)

        #expect(service.fetchRates().isEmpty)
    }

    @Test func fetchRatesReturnsSeededCurrencies() {
        let (persistence, _) = InMemoryTestStack.makeSeeded()
        let service = ExchangeRateService(context: persistence.container.viewContext)

        let rates = service.fetchRates()

        #expect(rates.count == 2)
        #expect(rates.map(\.currencyCode).sorted() == ["EUR", "USD"])
        #expect(rates.first { $0.currencyCode == "USD" }?.buyRate == 92.40)
    }
}
