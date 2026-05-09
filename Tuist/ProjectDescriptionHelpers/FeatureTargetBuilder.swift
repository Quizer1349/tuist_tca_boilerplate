import ProjectDescription

/// One-stop builder for a feature module + its companion test target.
///
/// Usage in `Project.swift`:
/// ```
/// FeatureTargetBuilder(
///   "MyFeature",
///   dependencies: [.composableArchitecture, .designSystem]
/// )
/// ```
///
/// Pass `resources: true` if the module ships resources (asset catalogs, strings).
/// Pass `isRoot: true` for app-only features (entry points). The Tuist manifest validator
/// in `LayerEnforcement` aborts generation if any sibling lists a root in its dependencies.
public struct FeatureTargetBuilder: Sendable {
  public let name: String
  public let isRoot: Bool
  private let dependencies: [TargetDependency]
  private let hasResources: Bool

  public init(
    _ name: String,
    dependencies: [TargetDependency] = [],
    resources: Bool = false,
    isRoot: Bool = false
  ) {
    self.name = name
    self.isRoot = isRoot
    self.dependencies = dependencies
    self.hasResources = resources
  }

  public func withTests() -> [Target] {
    [framework(), tests()]
  }

  public var testableTarget: TestableTarget {
    .testableTarget(target: .target("\(name)Tests"))
  }

  /// Aborts project generation if this feature lists a forbidden target as a dependency.
  /// Used to enforce that root features (app-only) are not depended on by sibling features.
  public func assertDoesNotDependOn(_ forbidden: Set<String>) {
    for dep in dependencies {
      guard let depName = Self.extractTargetName(dep), forbidden.contains(depName) else {
        continue
      }
      fatalError(
        "Feature '\(name)' may not depend on '\(depName)': it is a root feature " +
        "(app-only). Move shared logic into Domain/Client/DesignSystem instead."
      )
    }
  }

  /// Pulls the target name out of a `.target(name:)` TargetDependency case.
  /// Returns nil for `.external`, `.sdk`, `.framework`, etc. Uses Mirror so it tolerates
  /// Tuist API churn (single-string vs. multi-arg associated values).
  private static func extractTargetName(_ dep: TargetDependency) -> String? {
    let mirror = Mirror(reflecting: dep)
    guard let firstChild = mirror.children.first, firstChild.label == "target" else {
      return nil
    }
    if let direct = firstChild.value as? String {
      return direct
    }
    let assocMirror = Mirror(reflecting: firstChild.value)
    for child in assocMirror.children where child.label == "name" {
      return child.value as? String
    }
    return nil
  }

  private func framework() -> Target {
    .target(
      name: name,
      destinations: .iOS,
      product: .framework,
      bundleId: AppConfig.bundleId(name.lowercased()),
      deploymentTargets: AppConfig.deploymentTarget,
      sources: ["Features/\(name)/Sources/**"],
      resources: hasResources ? ["Features/\(name)/Resources/**"] : [],
      dependencies: dependencies
    )
  }

  private func tests() -> Target {
    .target(
      name: "\(name)Tests",
      destinations: .iOS,
      product: .unitTests,
      bundleId: AppConfig.bundleId("\(name.lowercased()).tests"),
      deploymentTargets: AppConfig.deploymentTarget,
      sources: ["Features/\(name)/Tests/**"],
      dependencies: [.target(name: name), .snapshotTesting] + dependencies
    )
  }
}
