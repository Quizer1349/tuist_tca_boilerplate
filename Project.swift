import ProjectDescription
import ProjectDescriptionHelpers

private let features: [FeatureTargetBuilder] = [
  FeatureTargetBuilder(
    "AppCoreFeature",
    dependencies: [
      .composableArchitecture,
      .hapticClient,
      .designSystem,
      .target(name: "ExampleFeature"),
    ],
    isRoot: true
  ),
  FeatureTargetBuilder(
    "ExampleFeature",
    dependencies: [.composableArchitecture, .hapticClient, .designSystem]
  ),
  FeatureTargetBuilder("HapticClient", dependencies: [.composableArchitecture]),
  FeatureTargetBuilder("DesignSystem", resources: true),
  // tuist-marker: insert new features above this line
]

private let appTarget: Target = .target(
  name: AppConfig.projectName,
  destinations: .iOS,
  product: .app,
  bundleId: AppConfig.bundleId("app"),
  deploymentTargets: AppConfig.deploymentTarget,
  infoPlist: .appDefault,
  sources: ["App/Sources/**"],
  resources: ["App/Resources/**"],
  dependencies: [
    .target(name: "AppCoreFeature"),
    .target(name: "HapticClient"),
  ]
)

let project: Project = {
  assertNoRootDependencies(features)
  return Project(
    name: AppConfig.projectName,
    options: .options(developmentRegion: AppConfig.developmentRegion),
    targets: [appTarget] + features.flatMap { $0.withTests() },
    schemes: [
      .scheme(
        name: AppConfig.projectName,
        buildAction: .buildAction(targets: [.target(AppConfig.projectName)]),
        testAction: .targets(features.map { $0.testableTarget })
      )
    ]
  )
}()
