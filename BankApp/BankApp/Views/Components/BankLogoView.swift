//
//  BankLogoView.swift
//  BankApp
//

import SwiftUI

struct BankLogoView: View {
    var body: some View {
        Text("СБ")
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(.primary)
            .frame(width: 40, height: 40)
            .background(Color.bankLogoBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
