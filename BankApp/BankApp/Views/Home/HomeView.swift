//
//  HomeView.swift
//  BankApp
//

import SwiftUI
import Combine

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @Environment(\.appDependencies) private var appDependencies
    @StateObject private var viewModel: HomeViewModel

    init(user: UserSession, dependencies: AppDependencies) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(
            user: user,
            accountService: dependencies.accountService,
            exchangeRateService: dependencies.exchangeRateService
        ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    summaryCard
                    servicesSection
                    branchesSection
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
            .background(Color.bankCardBackground)
            .navigationBarHidden(true)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.greeting)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Text(viewModel.displayName)
                    .font(.largeTitle.bold())
                    .accessibilityIdentifier(AccessibilityID.homeDisplayName)
            }
            Spacer()
            Image(systemName: "person.crop.circle")
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 44, height: 44)
                .background(Color(.systemBackground))
                .clipShape(Circle())
        }
        .padding(.top, 8)
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("home.summary.title")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))

            VStack(alignment: .leading, spacing: 6) {
                Text("home.summary.available")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.85))
                Text(MoneyFormatting.rubles(viewModel.summary.totalAvailable))
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(.white)
                    .accessibilityIdentifier(AccessibilityID.homeSummaryAmount)
            }

            HStack(alignment: .bottom) {
                Spacer(minLength: 12)
                Text("home.summary.updated \(MoneyFormatting.time(viewModel.summary.updatedAt))")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bankPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.services.title")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            if let user = session.currentUser, let appDependencies {
                NavigationLink {
                    AccountsListView(user: user, dependencies: appDependencies)
                } label: {
                    ServiceRowView(
                        title: "home.service.accounts.title",
                        subtitle: "home.service.accounts.subtitle",
                        showsChevron: true
                    )
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier(AccessibilityID.homeAccountsLink)
            }

            ratesCard
        }
    }

    private var ratesCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("home.rates.title")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            HStack(alignment: .top, spacing: 16) {
                ForEach(viewModel.rates) { rate in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(rate.currencyCode)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(MoneyFormatting.rate(rate.buyRate))
                            .font(.title3.bold())
                        Text("home.rates.footer")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
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
    }

    private var branchesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("home.branches.title")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            if let appDependencies {
                NavigationLink {
                    BranchesMapView(dependencies: appDependencies)
                } label: {
                    VStack(spacing: 12) {
                        Image(systemName: "map")
                            .font(.title)
                            .foregroundStyle(Color.bankPrimary.opacity(0.7))
                        Text("home.branches.placeholder")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(
                            colors: [Color.bankPrimary.opacity(0.12), Color.bankCardBackground],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct ServiceRowView: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    var showsChevron = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.tertiary)
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
    }
}
