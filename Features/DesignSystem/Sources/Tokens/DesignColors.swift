import SwiftUI

public struct DesignColors: Equatable, Sendable {
  // System semantic — auto-adapt for dark mode + high contrast
  public let backgroundPrimary: Color
  public let backgroundSurface: Color
  public let textPrimary: Color
  public let textSecondary: Color

  // Brand — Figma parity, defined in Swift
  public let brandPrimary: Color
  public let brandPrimaryForeground: Color

  public init(
    backgroundPrimary: Color,
    backgroundSurface: Color,
    textPrimary: Color,
    textSecondary: Color,
    brandPrimary: Color,
    brandPrimaryForeground: Color
  ) {
    self.backgroundPrimary = backgroundPrimary
    self.backgroundSurface = backgroundSurface
    self.textPrimary = textPrimary
    self.textSecondary = textSecondary
    self.brandPrimary = brandPrimary
    self.brandPrimaryForeground = brandPrimaryForeground
  }

  public static let `default` = DesignColors(
    backgroundPrimary: DesignSystemAsset.Colors.backgroundPrimary.swiftUIColor,
    backgroundSurface: DesignSystemAsset.Colors.backgroundSurface.swiftUIColor,
    textPrimary: .primary,
    textSecondary: .secondary,
    brandPrimary: Color(hex: "#FF9500"),
    brandPrimaryForeground: Color(hex: "#FFFFFF")
  )
}
