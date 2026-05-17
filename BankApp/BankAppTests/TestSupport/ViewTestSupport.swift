//
//  ViewTestSupport.swift
//  BankAppTests
//

import CoreData
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
        let (controller, session) = TestPersistence.makeSeeded()
        let dependencies = AppDependencies(persistence: controller)
        return (dependencies, SessionStore(), session)
    }
}
