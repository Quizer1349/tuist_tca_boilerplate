import ProjectDescription

/// Convenience static accessors for commonly-referenced targets and external SPM packages.
/// Use these in `Project.swift`'s feature dependency arrays for a more readable graph.
///
/// `make client NAME=Foo` auto-inserts a new line above the marker below.
public extension TargetDependency {
  static let composableArchitecture: Self = .external(name: "ComposableArchitecture")
  static let hapticClient: Self = .target(name: "HapticClient")
  static let snapshotTesting: Self = .external(name: "SnapshotTesting")
  static let designSystem: Self = .target(name: "DesignSystem")
  // tuist-marker: insert new client deps above this line
}
