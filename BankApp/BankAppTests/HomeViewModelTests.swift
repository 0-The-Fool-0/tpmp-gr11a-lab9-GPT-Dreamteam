//
//  HomeViewModelTests.swift
//  BankAppTests
//

import CoreData
import Foundation
import Testing
@testable import BankApp

@MainActor
struct HomeViewModelTests {
    @Test func reloadLoadsDisplayNameSummaryAndRates() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let viewModel = HomeViewModel(
            user: session,
            accountService: AccountService(context: persistence.container.viewContext),
            exchangeRateService: ExchangeRateService(context: persistence.container.viewContext)
        )

        #expect(viewModel.displayName == "Елена")
        #expect(viewModel.summary.totalAvailable == 918_420)
        #expect(viewModel.rates.count == 2)
        #expect(!viewModel.greeting.isEmpty)
    }

    @Test(arguments: [
        (8, "home.greeting.morning"),
        (13, "home.greeting.afternoon"),
        (18, "home.greeting.evening"),
        (23, "home.greeting.night"),
    ])
    func greetingForHour(hour: Int, expectedKey: String) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        var components = DateComponents()
        components.year = 2026
        components.month = 5
        components.day = 17
        components.hour = hour
        components.minute = 0
        let date = calendar.date(from: components)!

        let greeting = HomeViewModel.greeting(for: date, calendar: calendar)

        #expect(greeting == String(localized: String.LocalizationValue(expectedKey)))
    }

    @Test func reloadRefreshesSummaryAndRates() {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let viewModel = HomeViewModel(
            user: session,
            accountService: AccountService(context: persistence.container.viewContext),
            exchangeRateService: ExchangeRateService(context: persistence.container.viewContext)
        )
        viewModel.reload()
        #expect(viewModel.summary.totalAvailable == 918_420)
        #expect(viewModel.rates.count == 2)
    }
}
