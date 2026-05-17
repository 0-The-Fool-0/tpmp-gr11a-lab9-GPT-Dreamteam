//
//  BankAppUITests.swift
//  BankAppUITests
//

import XCTest

final class BankAppUITests: XCTestCase {
  private var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["-UITesting"]

    addUIInterruptionMonitor(withDescription: "Save password") { alert in
      Self.dismissSavePasswordAlert(alert)
    }
  }

  @MainActor
  func testLoginScreenIsShownOnLaunch() throws {
    app.launch()

    XCTAssertTrue(app.textFields[AccessibilityID.loginField].waitForExistence(timeout: 5))
    XCTAssertTrue(app.secureTextFields[AccessibilityID.passwordField].exists)
    XCTAssertTrue(app.buttons[AccessibilityID.signInButton].exists)
  }

  @MainActor
  func testInvalidLoginShowsError() throws {
    app.launch()

    app.textFields[AccessibilityID.loginField].tap()
    app.textFields[AccessibilityID.loginField].typeText("wrong.user")
    app.secureTextFields[AccessibilityID.passwordField].tap()
    app.secureTextFields[AccessibilityID.passwordField].typeText("wrong")
    app.buttons[AccessibilityID.signInButton].tap()

    XCTAssertTrue(app.staticTexts[AccessibilityID.loginError].waitForExistence(timeout: 3))
  }

  @MainActor
  func testSuccessfulLoginShowsHomeSummary() throws {
    app.launch()
    signIn()

    XCTAssertTrue(app.staticTexts[AccessibilityID.homeDisplayName].waitForExistence(timeout: 5))
    XCTAssertEqual(app.staticTexts[AccessibilityID.homeDisplayName].label, "Елена")
    XCTAssertTrue(app.staticTexts[AccessibilityID.homeSummaryAmount].label.contains("918"))
  }

  @MainActor
  func testAccountsListOpensFromHome() throws {
    app.launch()
    signIn()

    let accountsLink = app.buttons[AccessibilityID.homeAccountsLink]
    XCTAssertTrue(accountsLink.waitForExistence(timeout: 5))
    accountsLink.tap()

    let accountsList = app.descendants(matching: .any)[AccessibilityID.accountsList]
    XCTAssertTrue(accountsList.waitForExistence(timeout: 8))

    let cards = accountsList.descendants(matching: .any).matching(identifier: AccessibilityID.accountCard)
    XCTAssertTrue(cards.element(boundBy: 0).waitForExistence(timeout: 8))
    XCTAssertGreaterThanOrEqual(cards.count, 5)
  }

  private func signIn() {
    let loginField = app.textFields[AccessibilityID.loginField]
    XCTAssertTrue(loginField.waitForExistence(timeout: 5))
    loginField.tap()
    loginField.typeText("elena.kuznetsova")

    let passwordField = app.secureTextFields[AccessibilityID.passwordField]
    passwordField.tap()
    passwordField.typeText("demo1234")

    app.buttons[AccessibilityID.signInButton].tap()
    waitForHomeAfterSignIn()
  }

  private func waitForHomeAfterSignIn() {
    let homeDisplayName = app.staticTexts[AccessibilityID.homeDisplayName]
    let deadline = Date().addingTimeInterval(12)
    while Date() < deadline {
      if homeDisplayName.exists { return }
      _ = dismissSavePasswordPrompt(timeout: 0.5)
    }
    XCTAssertTrue(
      homeDisplayName.waitForExistence(timeout: 2),
      "Home screen did not appear; Save Password sheet may still be blocking the UI"
    )
  }

  /// iOS shows "Save Password" as an in-app sheet, not a Springboard alert.
  @discardableResult
  private func dismissSavePasswordPrompt(timeout: TimeInterval = 8) -> Bool {
    let deadline = Date().addingTimeInterval(timeout)
    while Date() < deadline {
      if tapSavePasswordDismissButton(in: app) { return true }

      let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
      if tapSavePasswordDismissButton(in: springboard) { return true }

      RunLoop.current.run(until: Date().addingTimeInterval(0.25))
    }
    return false
  }

  @discardableResult
  private func tapSavePasswordDismissButton(in application: XCUIApplication) -> Bool {
    let labels = [
      "Not Now", "Not now", "Не сейчас", "Не Сейчас",
      "Never", "Никогда", "Non ora", "Pas maintenant",
    ]

    for label in labels {
      let paths: [XCUIElement] = [
        application.scrollViews.otherElements.buttons[label],
        application.buttons[label],
        application.sheets.buttons[label],
        application.alerts.buttons[label],
      ]
      for button in paths where button.exists {
        button.tap()
        return true
      }
    }

    let predicate = NSPredicate(
      format: "elementType == %d AND (label CONTAINS[c] 'not now' OR label CONTAINS[c] 'не сейчас' OR label CONTAINS[c] 'never' OR label CONTAINS[c] 'никогда')",
      XCUIElement.ElementType.button.rawValue
    )
    let matched = application.descendants(matching: .button).matching(predicate)
    if matched.firstMatch.waitForExistence(timeout: 0.5) {
      matched.firstMatch.tap()
      return true
    }

    return false
  }

  @discardableResult
  private static func dismissSavePasswordAlert(_ alert: XCUIElement) -> Bool {
    for title in ["Not Now", "Not now", "Не сейчас", "Never", "Никогда"] {
      let button = alert.buttons[title]
      if button.exists {
        button.tap()
        return true
      }
    }
    if alert.buttons.count >= 2 {
      alert.buttons.element(boundBy: 1).tap()
      return true
    }
    return false
  }
}

private enum AccessibilityID {
  static let loginField = "login.field"
  static let passwordField = "login.password"
  static let signInButton = "login.signIn"
  static let loginError = "login.error"
  static let homeDisplayName = "home.displayName"
  static let homeSummaryAmount = "home.summaryAmount"
  static let homeAccountsLink = "home.accountsLink"
  static let accountsList = "accounts.list"
  static let accountCard = "account.card"
}
