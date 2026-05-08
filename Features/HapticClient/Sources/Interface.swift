import ComposableArchitecture

public enum HapticEvent: Sendable, Equatable {
  case selection
  case success
  case warning
  case error
  case lightTap
  case mediumTap
  case heavyTap
}

@DependencyClient
public struct HapticClient: Sendable {
  public var play: @Sendable (_ event: HapticEvent) async -> Void
}
