import Dependencies

public extension DependencyValues {
  var hapticClient: HapticClient {
    get { self[HapticClient.self] }
    set { self[HapticClient.self] = newValue }
  }
}

extension HapticClient: TestDependencyKey {
  public static let testValue = Self.noop
  public static let previewValue = Self.noop
}

public extension HapticClient {
  static let noop = Self(
    play: { _ in }
  )
}
