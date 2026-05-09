import ComposableArchitecture
import ExampleFeature
import HapticClient

@Reducer
public struct AppCoreFeature {
  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case example(ExampleFeature)
  }

  @Dependency(\.hapticClient) private var hapticClient

  @ObservableState
  public struct State: Equatable {
    public var path = StackState<Path.State>()
    @Presents public var sheet: ExampleFeature.State?
    public init() {}
  }

  public enum Action: ViewAction {
    case view(View)
    case appDelegate(Interface)
    case path(StackActionOf<Path>)
    case sheet(PresentationAction<ExampleFeature.Action>)

    @CasePathable
    public enum View {
      case onAppear
      case startButtonTapped
      case sheetButtonTapped
    }

    @CasePathable
    public enum Interface: Equatable {
      case didFinishLaunching
    }
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .view(.onAppear):
        return .none

      case .view(.startButtonTapped):
        state.path.append(.example(ExampleFeature.State()))
        return .run { [hapticClient = self.hapticClient] _ in
          await hapticClient.play(.mediumTap)
        }

      case .view(.sheetButtonTapped):
        state.sheet = ExampleFeature.State(counter: 100)
        return .run { [hapticClient = self.hapticClient] _ in
          await hapticClient.play(.selection)
        }

      case .appDelegate(.didFinishLaunching):
        return .none

      case .path, .sheet:
        return .none
      }
    }
    .ifLet(\.$sheet, action: \.sheet) {
      ExampleFeature()
    }
    .forEach(\.path, action: \.path)
  }
}
