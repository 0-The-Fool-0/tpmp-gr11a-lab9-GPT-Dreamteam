//
//  AccountTagView.swift
//  BankApp
//

import SwiftUI

struct AccountTagView: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.caption2.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.bankLogoBackground)
            .clipShape(Capsule())
    }
}
