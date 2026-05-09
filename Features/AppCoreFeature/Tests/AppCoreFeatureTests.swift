@testable import AppCoreFeature
import ComposableArchitecture
import ExampleFeature
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

  @Test("startButtonTapped pushes example onto path and plays medium tap haptic")
  func startButtonTapped() async {
    let captured = LockIsolated<HapticEvent?>(nil)
    let store = makeStore {
      $0.hapticClient.play = { captured.setValue($0) }
    }

    await store.send(.view(.startButtonTapped)) {
      $0.path.append(.example(ExampleFeature.State()))
    }
    await store.finish()

    captured.withValue { #expect($0 == .mediumTap) }
  }

  @Test("sheetButtonTapped presents example sheet and plays selection haptic")
  func sheetButtonTapped() async {
    let captured = LockIsolated<HapticEvent?>(nil)
    let store = makeStore {
      $0.hapticClient.play = { captured.setValue($0) }
    }

    await store.send(.view(.sheetButtonTapped)) {
      $0.sheet = ExampleFeature.State(counter: 100)
    }
    await store.finish()

    captured.withValue { #expect($0 == .selection) }
  }

  @Test("sheet dismiss clears the presented state")
  func sheetDismiss() async {
    var initialState = AppCoreFeature.State()
    initialState.sheet = .init(counter: 42)
    let store = makeStore(initialState: initialState)

    await store.send(.sheet(.dismiss)) {
      $0.sheet = nil
    }
  }
}
