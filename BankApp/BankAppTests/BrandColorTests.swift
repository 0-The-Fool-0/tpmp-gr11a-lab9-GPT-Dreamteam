//
//  BrandColorTests.swift
//  BankAppTests
//

import SwiftUI
import Testing
@testable import BankApp

struct BrandColorTests {
    @Test func brandPaletteIsDefined() {
        #expect(Color.bankPrimary != Color.clear)
        #expect(Color.bankCardBackground != Color.clear)
        #expect(Color.bankFieldBorder != Color.clear)
        #expect(Color.bankLogoBackground != Color.clear)
    }
}
