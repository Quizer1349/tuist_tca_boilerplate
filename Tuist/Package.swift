// swift-tools-version: 5.10
// Tuist reads this file to resolve and integrate SPM dependencies.
// Run `make generate` after editing.

import PackageDescription

let package = Package(
  name: "AppPackages",
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: "1.15.0"
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-snapshot-testing",
      from: "1.17.0"
    ),
    .package(
      url: "https://github.com/SimplyDanny/SwiftLintPlugins",
      from: "0.63.2"
    ),
  ]
)

#if TUIST
  import ProjectDescription

  // Use dynamic frameworks for shared SPM packages so there is a single shared
  // dependency registry across all dynamic feature frameworks at runtime.
  // Static linking would give each framework its own isolated registry copy,
  // causing "no live implementation" errors for DependencyKey conformances.
  let packageSettings = PackageSettings(
    productTypes: [
      "CasePaths": .framework,
      "Clocks": .framework,
      "CombineSchedulers": .framework,
      "ComposableArchitecture": .framework,
      "ConcurrencyExtras": .framework,
      "CustomDump": .framework,
      "Dependencies": .framework,
      "DependenciesMacros": .framework,
      "IdentifiedCollections": .framework,
      "InternalCollectionsUtilities": .framework,
      "OrderedCollections": .framework,
      "Perception": .framework,
      "XCTestDynamicOverlay": .framework,
    ]
  )
#endif
