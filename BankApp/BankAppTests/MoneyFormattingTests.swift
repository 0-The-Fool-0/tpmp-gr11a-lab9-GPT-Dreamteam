//
//  MoneyFormattingTests.swift
//  BankAppTests
//

import Foundation
import Testing
@testable import BankApp

struct MoneyFormattingTests {
    @Test func rublesFormatsWithGroupingAndCurrency() {
        let formatted = MoneyFormatting.rubles(242_900)
        #expect(formatted.contains("242"))
        #expect(formatted.contains("900"))
        #expect(formatted.contains("₽"))
    }

    @Test func rateUsesTwoFractionDigitsAndCommaSeparator() {
        let formatted = MoneyFormatting.rate(92.4)
        #expect(formatted.contains("92,40"))
        #expect(formatted.contains("₽"))
    }

    @Test func rublesFormatsZero() {
        #expect(MoneyFormatting.rubles(0).contains("0"))
        #expect(MoneyFormatting.rubles(0).contains("₽"))
    }

    @Test func rublesFormatsNegativeBalance() {
        let formatted = MoneyFormatting.rubles(-180_000)
        #expect(formatted.contains("180"))
        #expect(formatted.contains("₽"))
    }

    @Test func rateFormatsLargeValue() {
        let formatted = MoneyFormatting.rate(1_000.5)
        #expect(formatted.contains("₽"))
        #expect(formatted.contains(",")
            || formatted.contains("."))
    }

    @Test func timeUsesHourAndMinute() throws {
        var components = DateComponents()
        components.year = 2026
        components.month = 5
        components.day = 17
        components.hour = 9
        components.minute = 38
        let calendar = Calendar(identifier: .gregorian)
        let date = try #require(calendar.date(from: components))
        #expect(MoneyFormatting.time(date) == "09:38")
    }
}
