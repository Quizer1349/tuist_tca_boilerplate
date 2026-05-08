import SwiftUI

public struct DesignSpacing: Equatable, Sendable {
  // Numeric scale — primitive tokens
  public let xs: CGFloat
  public let sm: CGFloat
  public let md: CGFloat
  public let lg: CGFloat
  public let xl: CGFloat

  // Semantic — intent-named (prefer these in views)
  public let screenPadding: CGFloat
  public let sectionGap: CGFloat
  public let cardPadding: CGFloat
  public let controlInset: CGFloat

  public init(
    xs: CGFloat = 4,
    sm: CGFloat = 8,
    md: CGFloat = 16,
    lg: CGFloat = 24,
    xl: CGFloat = 32,
    screenPadding: CGFloat = 16,
    sectionGap: CGFloat = 24,
    cardPadding: CGFloat = 16,
    controlInset: CGFloat = 12
  ) {
    self.xs = xs
    self.sm = sm
    self.md = md
    self.lg = lg
    self.xl = xl
    self.screenPadding = screenPadding
    self.sectionGap = sectionGap
    self.cardPadding = cardPadding
    self.controlInset = controlInset
  }

  public static let `default` = DesignSpacing()
}
