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

    XCTAssertTrue(app.otherElements[AccessibilityID.accountsList].waitForExistence(timeout: 5))
    XCTAssertEqual(app.otherElements.matching(identifier: AccessibilityID.accountCard).count, 5)
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
