import SwiftUI

public extension View {
  /// Horizontal screen-edge padding from the design system.
  func screenPadding() -> some View {
    modifier(ScreenPaddingModifier())
  }

  /// Standard surface card visual: surface background, medium radius, subtle shadow.
  func cardStyle() -> some View {
    modifier(CardStyleModifier())
  }
}

private struct ScreenPaddingModifier: ViewModifier {
  @Environment(\.designSpacing) private var spacing

  func body(content: Content) -> some View {
    content.padding(.horizontal, spacing.screenPadding)
  }
}

private struct CardStyleModifier: ViewModifier {
  @Environment(\.designColors) private var colors
  @Environment(\.designSpacing) private var spacing
  @Environment(\.designRadius) private var radius

  func body(content: Content) -> some View {
    content
      .padding(spacing.cardPadding)
      .background(colors.backgroundSurface)
      .clipShape(RoundedRectangle(cornerRadius: radius.medium))
      .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
  }
}
