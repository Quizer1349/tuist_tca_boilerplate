import ProjectDescription

/// Shared `Info.plist` defaults for the App target. Extend in `Project.swift` per-target
/// if a feature module needs additional plist keys.
public extension InfoPlist {
  static let appDefault: Self = .extendingDefault(with: [
    "CFBundleDisplayName": "$(PRODUCT_NAME)",
    "UILaunchScreen": ["UIColorName": "", "UIImageName": ""],
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
  ])
}
