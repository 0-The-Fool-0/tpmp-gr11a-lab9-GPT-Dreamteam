//
//  AccountEnums.swift
//  BankApp
//

import Foundation

enum AccountType: String, CaseIterable {
    case current
    case savings
    case credit
    case card
}

enum CardSubtype: String {
    case payroll
    case savings
    case credit
}

enum AccountStatus: String {
    case active
    case blocked
    case closed
}

struct UserSession: Identifiable, Equatable {
    let id: UUID
    let login: String
    let displayName: String
}

struct AccountItem: Identifiable, Equatable {
    let id: UUID
    let accountNumber: String
    let type: AccountType
    let cardSubtype: CardSubtype?
    let status: AccountStatus
    let titleKey: String
    let subtitleKey: String
    let balance: Double
    let balanceLabelKey: String
    let footerKey: String?
    let overdraftLimit: Double?
    let sortOrder: Int

    var title: String { String(localized: String.LocalizationValue(titleKey)) }
    var subtitle: String { String(localized: String.LocalizationValue(subtitleKey)) }
    var balanceLabel: String { String(localized: String.LocalizationValue(balanceLabelKey)) }
    var footer: String? {
        guard let footerKey else { return nil }
        return String(localized: String.LocalizationValue(footerKey))
    }

    var typeTag: String {
        switch type {
        case .current: return String(localized: "account.tag.current")
        case .savings: return String(localized: "account.tag.savings")
        case .credit: return String(localized: "account.tag.credit")
        case .card: return String(localized: "account.tag.card")
        }
    }

    var statusTag: String {
        switch status {
        case .active: return String(localized: "account.tag.active")
        case .blocked: return String(localized: "account.tag.blocked")
        case .closed: return String(localized: "account.tag.closed")
        }
    }
}

struct RateItem: Identifiable, Equatable {
    let id: String
    let currencyCode: String
    let buyRate: Double
    let updatedAt: Date
}

struct BranchItem: Identifiable, Equatable {
    let id: UUID
    let nameKey: String
    let address: String
    let latitude: Double
    let longitude: Double

    var name: String { String(localized: String.LocalizationValue(nameKey)) }
}

struct AccountSummary {
    let totalAvailable: Double
    let updatedAt: Date
}
