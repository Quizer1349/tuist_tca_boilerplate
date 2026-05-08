import SwiftUI

public struct DesignFonts: Equatable, Sendable {
  public let hero: Font // big number/temperature display
  public let title: Font // screen titles
  public let subtitle: Font // section headers
  public let body: Font // default reading text
  public let note: Font // smaller, muted
  public let caption: Font // metadata, smallest

  public init(
    hero: Font = .system(size: 64, weight: .semibold, design: .serif),
    title: Font = .system(size: 28, weight: .semibold),
    subtitle: Font = .system(size: 20, weight: .medium),
    body: Font = .system(size: 16, weight: .regular),
    note: Font = .system(size: 14, weight: .regular),
    caption: Font = .system(size: 12, weight: .regular)
  ) {
    self.hero = hero
    self.title = title
    self.subtitle = subtitle
    self.body = body
    self.note = note
    self.caption = caption
  }

  public static let `default` = DesignFonts()
}
