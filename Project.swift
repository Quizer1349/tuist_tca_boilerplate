import ProjectDescription
import ProjectDescriptionHelpers

private let features: [FeatureTargetBuilder] = [
  FeatureTargetBuilder(
    "AppCoreFeature",
    dependencies: [.composableArchitecture, .hapticClient, .designSystem],
    isRoot: true
  ),
  FeatureTargetBuilder("HapticClient", dependencies: [.composableArchitecture]),
  FeatureTargetBuilder("DesignSystem", resources: true),
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
