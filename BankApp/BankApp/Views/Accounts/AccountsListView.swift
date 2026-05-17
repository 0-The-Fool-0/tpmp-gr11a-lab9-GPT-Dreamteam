//
//  AccountsListView.swift
//  BankApp
//

import SwiftUI

struct AccountsListView: View {
    @StateObject private var viewModel: AccountsViewModel

    init(user: UserSession, dependencies: AppDependencies) {
        _viewModel = StateObject(wrappedValue: AccountsViewModel(
            userID: user.id,
            accountService: dependencies.accountService
        ))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.accounts) { account in
                    AccountCardView(account: account)
                }
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 24)
        }
        .accessibilityIdentifier(AccessibilityID.accountsList)
        .background(Color.bankCardBackground)
        .navigationTitle("accounts.title")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { viewModel.reload() }
    }
}

#Preview {
    AccountsListView(user: UserSession(id: UUID(), login: "Login", displayName: "Name"), dependencies: AppDependencies())
}
