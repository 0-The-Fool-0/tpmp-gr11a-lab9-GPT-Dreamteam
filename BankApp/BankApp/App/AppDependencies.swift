//
//  AppDependencies.swift
//  BankApp
//

import CoreData
import SwiftUI
import Combine

@MainActor
final class AppDependencies: ObservableObject {
    let persistence: PersistenceController
    let authService: AuthService
    let accountService: AccountService
    let exchangeRateService: ExchangeRateService
    let branchService: BranchService

    var viewContext: NSManagedObjectContext {
        persistence.container.viewContext
    }

    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-UITesting")
    }

    init(persistence: PersistenceController? = nil) {
        let resolvedPersistence = persistence ?? {
            if Self.isUITesting {
                return .testing
            }
            if PersistenceController.isRunningUnitTests {
                return .testing
            }
            return .shared
        }()
        self.persistence = resolvedPersistence
        let context = resolvedPersistence.container.viewContext
        // Skip auto-seed only for the empty test-host app; explicit persistence still seeds.
        let shouldSeedOnLaunch = !PersistenceController.isRunningUnitTests || persistence != nil
        if shouldSeedOnLaunch {
            DataSeedService(context: context).seedIfNeeded()
        }
        authService = AuthService(context: context)
        accountService = AccountService(context: context)
        exchangeRateService = ExchangeRateService(context: context)
        branchService = BranchService(context: context)
    }
}

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies? = nil
}

extension EnvironmentValues {
    var appDependencies: AppDependencies? {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
