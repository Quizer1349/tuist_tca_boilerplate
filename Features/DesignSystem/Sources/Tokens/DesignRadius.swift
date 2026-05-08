import SwiftUI

public struct DesignRadius: Equatable, Sendable {
  public let small: CGFloat
  public let medium: CGFloat
  public let large: CGFloat
  public let pill: CGFloat

  public init(
    small: CGFloat = 8,
    medium: CGFloat = 12,
    large: CGFloat = 20,
    pill: CGFloat = 999
  ) {
    self.small = small
    self.medium = medium
    self.large = large
    self.pill = pill
  }

  public static let `default` = DesignRadius()
}
