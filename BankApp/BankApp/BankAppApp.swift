//
//  BankAppApp.swift
//  BankApp
//

import CoreData
import SwiftUI

@main
struct BankAppApp: App {
    @StateObject private var dependencies = AppDependencies()
    @StateObject private var session = SessionStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .environment(\.managedObjectContext, dependencies.viewContext)
                .environment(\.appDependencies, dependencies)
        }
    }
}
