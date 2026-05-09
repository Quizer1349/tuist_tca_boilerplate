import ComposableArchitecture
import HapticClient

@Reducer
public struct ExampleFeature {
  @Dependency(\.hapticClient) private var hapticClient

  @ObservableState
  public struct State: Equatable {
    public var counter: Int

    public init(counter: Int = 0) {
      self.counter = counter
    }
  }

  public enum Action: ViewAction, Equatable {
    case view(View)
    case delegate(Delegate)

    @CasePathable
    public enum View: Equatable {
      case incrementButtonTapped
      case decrementButtonTapped
      case resetButtonTapped
    }

    @CasePathable
    public enum Delegate: Equatable {}
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.incrementButtonTapped):
        state.counter += 1
        return .run { [hapticClient = self.hapticClient] _ in
          await hapticClient.play(.lightTap)
        }

      case .view(.decrementButtonTapped):
        state.counter -= 1
        return .run { [hapticClient = self.hapticClient] _ in
          await hapticClient.play(.lightTap)
        }

      case .view(.resetButtonTapped):
        state.counter = 0
        return .run { [hapticClient = self.hapticClient] _ in
          await hapticClient.play(.success)
        }

      case .delegate:
        return .none
      }
    }
  }
}
