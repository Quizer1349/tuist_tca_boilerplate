@testable import AppCoreFeature
import ComposableArchitecture
import HapticClient
import Testing

@Suite("AppCoreFeature")
@MainActor
struct AppCoreFeatureTests {
  private func makeStore(
    initialState: AppCoreFeature.State = .init(),
    dependencies: (inout DependencyValues) -> Void = { _ in }
  ) -> TestStoreOf<AppCoreFeature> {
    TestStore(initialState: initialState) {
      AppCoreFeature()
    } withDependencies: {
      $0.hapticClient = .noop
      dependencies(&$0)
    }
  }

  @Test("onAppear produces no state change")
  func onAppear() async {
    let store = makeStore()
    await store.send(.view(.onAppear))
  }

  @Test("didFinishLaunching produces no state change")
  func didFinishLaunching() async {
    let store = makeStore()
    await store.send(.appDelegate(.didFinishLaunching))
  }

  @Test("startButtonTapped plays medium tap haptic")
  func startButtonTapped() async {
    let capturedEvent = LockIsolated<HapticEvent?>(nil)
    let store = makeStore {
      $0.hapticClient.play = { capturedEvent.setValue($0) }
    }

    await store.send(.view(.startButtonTapped))

    capturedEvent.withValue {
      #expect($0 == .mediumTap)
    }
  }
}
