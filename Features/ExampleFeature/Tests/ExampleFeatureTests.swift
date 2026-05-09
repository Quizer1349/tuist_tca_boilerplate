import ComposableArchitecture
@testable import ExampleFeature
import HapticClient
import Testing

@Suite("ExampleFeature")
@MainActor
struct ExampleFeatureTests {
  private func makeStore(
    initialState: ExampleFeature.State = .init(),
    dependencies: (inout DependencyValues) -> Void = { _ in }
  ) -> TestStoreOf<ExampleFeature> {
    TestStore(initialState: initialState) {
      ExampleFeature()
    } withDependencies: {
      $0.hapticClient = .noop
      dependencies(&$0)
    }
  }

  @Test("incrementButtonTapped raises counter and plays light tap haptic")
  func increment() async {
    let captured = LockIsolated<HapticEvent?>(nil)
    let store = makeStore(initialState: .init(counter: 4)) {
      $0.hapticClient.play = { captured.setValue($0) }
    }

    await store.send(.view(.incrementButtonTapped)) {
      $0.counter = 5
    }
    await store.finish()

    captured.withValue { #expect($0 == .lightTap) }
  }

  @Test("decrementButtonTapped lowers counter and plays light tap haptic")
  func decrement() async {
    let captured = LockIsolated<HapticEvent?>(nil)
    let store = makeStore(initialState: .init(counter: 1)) {
      $0.hapticClient.play = { captured.setValue($0) }
    }

    await store.send(.view(.decrementButtonTapped)) {
      $0.counter = 0
    }
    await store.finish()

    captured.withValue { #expect($0 == .lightTap) }
  }

  @Test("resetButtonTapped zeroes the counter and plays success haptic")
  func reset() async {
    let captured = LockIsolated<HapticEvent?>(nil)
    let store = makeStore(initialState: .init(counter: 17)) {
      $0.hapticClient.play = { captured.setValue($0) }
    }

    await store.send(.view(.resetButtonTapped)) {
      $0.counter = 0
    }
    await store.finish()

    captured.withValue { #expect($0 == .success) }
  }
}
