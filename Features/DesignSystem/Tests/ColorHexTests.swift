@testable import DesignSystem
import SwiftUI
import Testing

@Suite("Color hex initializer")
struct ColorHexTests {
  @Test("6-digit hex parses with full alpha")
  func sixDigit() {
    #expect(Color(hex: "#FF9500") == Color(red: 1, green: 149.0 / 255, blue: 0, opacity: 1))
  }

  @Test("Leading hash is optional")
  func noHash() {
    #expect(Color(hex: "FF9500") == Color(hex: "#FF9500"))
  }

  @Test("3-digit shorthand expands each digit")
  func threeDigit() {
    #expect(Color(hex: "#F60") == Color(hex: "#FF6600"))
  }

  @Test("8-digit hex applies leading alpha")
  func eightDigit() {
    let expected = Color(red: 1, green: 149.0 / 255, blue: 0, opacity: 128.0 / 255)
    #expect(Color(hex: "#80FF9500") == expected)
  }

  @Test("Whitespace and case are ignored")
  func tolerant() {
    #expect(Color(hex: "  #ff9500  ") == Color(hex: "#FF9500"))
  }

  @Test("Explicit opacity overrides any embedded alpha")
  func opacityOverride() {
    let actual = Color(hex: "#80FF9500", opacity: 0.5)
    let expected = Color(red: 1, green: 149.0 / 255, blue: 0, opacity: 0.5)
    #expect(actual == expected)
  }
}
