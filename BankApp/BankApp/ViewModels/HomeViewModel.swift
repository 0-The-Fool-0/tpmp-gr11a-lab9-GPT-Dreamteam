//
//  HomeViewModel.swift
//  BankApp
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var greeting = ""
    @Published private(set) var displayName = ""
    @Published private(set) var summary = AccountSummary(totalAvailable: 0, updatedAt: Date())
    @Published private(set) var rates: [RateItem] = []

    private let accountService: AccountService
    private let exchangeRateService: ExchangeRateService
    private let user: UserSession

    init(user: UserSession, accountService: AccountService, exchangeRateService: ExchangeRateService) {
        self.user = user
        self.accountService = accountService
        self.exchangeRateService = exchangeRateService
        reload()
    }

    func reload() {
        displayName = user.displayName
        greeting = Self.greeting(for: Date(), calendar: .current)
        summary = accountService.fetchSummary(for: user.id)
        rates = exchangeRateService.fetchRates()
    }

    static func greeting(for date: Date, calendar: Calendar = .current) -> String {
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 5..<12: return String(localized: "home.greeting.morning")
        case 12..<17: return String(localized: "home.greeting.afternoon")
        case 17..<22: return String(localized: "home.greeting.evening")
        default: return String(localized: "home.greeting.night")
        }
    }
}
