import ComposableArchitecture
import DesignSystem
import ExampleFeature
import SwiftUI

@ViewAction(for: AppCoreFeature.self)
public struct AppCoreView: View {
  @Bindable public var store: StoreOf<AppCoreFeature>

  public init(store: StoreOf<AppCoreFeature>) {
    self.store = store
  }

  @Environment(\.designSpacing) var spacing

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: spacing.md) {
        Image(uiImage: DesignSystemAsset.Icons.sun.image)
          .resizable()
          .frame(width: 100, height: 100)
        Text(DesignSystemStrings.appFeatureHello)
        Button(DesignSystemStrings.pushExampleButton) { send(.startButtonTapped) }
          .buttonStyle(.primary)
        Button(DesignSystemStrings.presentSheetButton) { send(.sheetButtonTapped) }
          .buttonStyle(.secondary)
      }
      .onAppear { send(.onAppear) }
    } destination: { store in
      switch store.case {
      case let .example(store):
        ExampleView(store: store)
      }
    }
    .sheet(item: $store.scope(state: \.sheet, action: \.sheet)) { sheetStore in
      NavigationStack {
        ExampleView(store: sheetStore)
      }
    }
  }
}

#if DEBUG
  #Preview {
    AppCoreView(
      store: Store(initialState: AppCoreFeature.State()) {
        AppCoreFeature()
      }
    )
  }
#endif
