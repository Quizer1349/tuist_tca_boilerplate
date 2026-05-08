import ComposableArchitecture
import HapticClient

@Reducer
public struct AppCoreFeature {
  @Dependency(\.hapticClient) private var hapticClient

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action: ViewAction {
    case view(View)
    case appDelegate(Interface)

    @CasePathable
    public enum View {
      case onAppear
      case startButtonTapped
    }

    @CasePathable
    public enum Interface: Equatable {
      case didFinishLaunching
    }
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .view(.onAppear):
        .none

      case .view(.startButtonTapped):
        .run { [hapticClient = self.hapticClient] _ in
          await hapticClient.play(.mediumTap)
        }

      case .appDelegate(.didFinishLaunching):
        .none
      }
    }
  }
}
