import ComposableArchitecture
import DesignSystem
import SwiftUI

@ViewAction(for: AppCoreFeature.self)
public struct AppCoreView: View {
  public let store: StoreOf<AppCoreFeature>

  public init(store: StoreOf<AppCoreFeature>) {
    self.store = store
  }

  @Environment(\.designSpacing) var spacing

  public var body: some View {
    VStack(spacing: spacing.md) {
      Image(uiImage: DesignSystemAsset.Icons.sun.image)
        .resizable()
        .frame(width: 100, height: 100)
      Text(DesignSystemStrings.appFeatureHello)
      Button("Start") {
        send(.startButtonTapped)
      }
      .buttonStyle(.primary)
    }
    .onAppear { send(.onAppear) }
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
