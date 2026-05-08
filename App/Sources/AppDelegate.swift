import AppCoreFeature
import ComposableArchitecture
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
  let store = Store(initialState: AppCoreFeature.State()) {
    AppCoreFeature()
  }

  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    store.send(.appDelegate(.didFinishLaunching))
    return true
  }
}
