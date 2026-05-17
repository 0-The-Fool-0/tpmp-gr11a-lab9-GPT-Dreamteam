//
//  BankAppUITestsLaunchTests.swift
//  BankAppUITests
//

import XCTest

final class BankAppUITestsLaunchTests: XCTestCase {
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    false
  }

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  @MainActor
  func testLaunchShowsLoginScreen() throws {
    let app = XCUIApplication()
    app.launchArguments = ["-UITesting"]
    app.launch()

    XCTAssertTrue(app.textFields["login.field"].waitForExistence(timeout: 5))

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Login Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
