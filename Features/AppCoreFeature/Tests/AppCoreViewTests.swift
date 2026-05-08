@testable import AppCoreFeature
import ComposableArchitecture
import HapticClient
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite("AppCoreView", .serialized)
@MainActor
struct AppCoreViewTests {
  private func makeViewController(
    userInterfaceStyle: UIUserInterfaceStyle = .light
  ) -> UIViewController {
    let controller = UIHostingController(
      rootView: AppCoreView(
        store: Store(initialState: AppCoreFeature.State()) {
          AppCoreFeature()
        } withDependencies: {
          $0.hapticClient = .noop
        }
      )
    )
    controller.overrideUserInterfaceStyle = userInterfaceStyle
    return controller
  }

  @Test("light mode")
  func lightMode() {
    assertSnapshot(of: makeViewController(), as: .image(on: .iPhone13Pro))
  }

  @Test("dark mode")
  func darkMode() {
    assertSnapshot(of: makeViewController(userInterfaceStyle: .dark), as: .image(on: .iPhone13Pro))
  }
}
