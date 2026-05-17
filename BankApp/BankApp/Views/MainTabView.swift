//
//  MainTabView.swift
//  BankApp
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.appDependencies) private var dependencies

    var body: some View {
        if let user = session.currentUser, let dependencies {
            TabView {
                HomeView(user: user, dependencies: dependencies)
                    .tabItem {
                        Label("tab.home", systemImage: "house.fill")
                    }

                PlaceholderTabView(titleKey: "tab.payments", systemImage: "creditcard")
                    .tabItem {
                        Label("tab.payments", systemImage: "creditcard")
                    }

                PlaceholderTabView(titleKey: "tab.support", systemImage: "magnifyingglass")
                    .tabItem {
                        Label("tab.support", systemImage: "magnifyingglass")
                    }

                PlaceholderTabView(titleKey: "tab.more", systemImage: "sparkles")
                    .tabItem {
                        Label("tab.more", systemImage: "sparkles")
                    }
            }
            .tint(.bankPrimary)
        }
    }
}

private struct PlaceholderTabView: View {
    let titleKey: LocalizedStringKey
    let systemImage: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(titleKey)
                .font(.title2.bold())
            Text("tab.placeholder")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bankCardBackground)
    }
}
