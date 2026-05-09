import ProjectDescription

/// Asserts that no non-root feature depends on a feature flagged `isRoot`.
/// Call this from `Project.swift` before constructing the `Project` value.
///
/// Roots (e.g. `AppCoreFeature`) compose siblings; siblings must NOT compose roots.
/// Cross-feature shared logic belongs in Domain/Client/DesignSystem, not in a root.
public func assertNoRootDependencies(_ features: [FeatureTargetBuilder]) {
  let rootNames = Set(features.filter(\.isRoot).map(\.name))
  for feature in features where !feature.isRoot {
    feature.assertDoesNotDependOn(rootNames)
  }
}
