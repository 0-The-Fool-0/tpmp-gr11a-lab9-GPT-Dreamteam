//
//  ViewTestSupport.swift
//  BankAppTests
//

import SwiftUI
import UIKit
@testable import BankApp

@MainActor
enum ViewTestSupport {
    static func host<V: View>(_ view: V) -> UIHostingController<V> {
        let controller = UIHostingController(rootView: view)
        controller.loadViewIfNeeded()
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()
        return controller
    }

    @MainActor
    static func seededDependencies() -> (AppDependencies, SessionStore, UserSession) {
        let (persistence, session) = InMemoryTestStack.makeSeeded()
        let dependencies = AppDependencies(persistence: persistence)
        return (dependencies, SessionStore(), session)
    }
}
