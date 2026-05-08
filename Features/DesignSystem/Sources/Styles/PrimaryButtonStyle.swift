import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    LabelView(configuration: configuration)
  }

  private struct LabelView: View {
    let configuration: ButtonStyle.Configuration
    @Environment(\.designColors) private var colors
    @Environment(\.designSpacing) private var spacing
    @Environment(\.designRadius) private var radius
    @Environment(\.designFonts) private var fonts
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
      configuration.label
        .font(fonts.body.weight(.semibold))
        .foregroundStyle(colors.brandPrimaryForeground)
        .padding(.horizontal, spacing.lg)
        .padding(.vertical, spacing.sm)
        .frame(minHeight: 44)
        .background(colors.brandPrimary)
        .clipShape(RoundedRectangle(cornerRadius: radius.small))
        .opacity(opacity)
    }

    private var opacity: Double {
      if !isEnabled { return 0.4 }
      if configuration.isPressed { return 0.8 }
      return 1
    }
  }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
  static var primary: Self {
    PrimaryButtonStyle()
  }
}
