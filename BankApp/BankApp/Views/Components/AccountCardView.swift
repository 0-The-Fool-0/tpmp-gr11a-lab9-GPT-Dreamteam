//
//  AccountCardView.swift
//  BankApp
//

import SwiftUI

struct AccountCardView: View {
    let account: AccountItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(account.title) · \(account.subtitle)")
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)

            Text(account.accountNumber)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                AccountTagView(text: account.typeTag)
                AccountTagView(text: account.statusTag)
            }

            HStack(alignment: .firstTextBaseline) {
                Text(MoneyFormatting.rubles(account.balance))
                    .font(.title2.bold())
                Spacer()
                Text(account.balanceLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }

            if let footer = account.footer {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.bankFieldBorder, lineWidth: 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(account.title) · \(account.subtitle)")
        .accessibilityIdentifier(AccessibilityID.accountCard)
    }
}
