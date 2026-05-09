import ComposableArchitecture
@testable import ExampleFeature
import HapticClient
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite("ExampleView", .serialized)
@MainActor
struct ExampleViewTests {
  private func makeViewController(
    counter: Int = 0,
    userInterfaceStyle: UIUserInterfaceStyle = .light
  ) -> UIViewController {
    let controller = UIHostingController(
      rootView: NavigationStack {
        ExampleView(
          store: Store(initialState: ExampleFeature.State(counter: counter)) {
            ExampleFeature()
          } withDependencies: {
            $0.hapticClient = .noop
          }
        )
      }
    )
    controller.overrideUserInterfaceStyle = userInterfaceStyle
    return controller
  }

  @Test("light mode")
  func lightMode() {
    assertSnapshot(of: makeViewController(counter: 7), as: .image(on: .iPhone13Pro))
  }

  @Test("dark mode")
  func darkMode() {
    assertSnapshot(
      of: makeViewController(counter: 7, userInterfaceStyle: .dark),
      as: .image(on: .iPhone13Pro)
    )
  }
}
