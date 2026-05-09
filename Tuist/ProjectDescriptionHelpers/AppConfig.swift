import ProjectDescription

/// Project-wide constants. Edit values here to rename the app, change the bundle prefix,
/// or shift the deployment target.
public enum AppConfig {
  public static let projectName = "App"
  public static let bundlePrefix = "com.app"
  public static let deploymentTarget: DeploymentTargets = .iOS("17.0")
  public static let developmentRegion = "en"

  public static func bundleId(_ suffix: String) -> String {
    "\(bundlePrefix).\(suffix)"
  }
}
