import ComposableArchitecture
import DesignSystem
import SwiftUI

@ViewAction(for: ExampleFeature.self)
public struct ExampleView: View {
  public let store: StoreOf<ExampleFeature>

  public init(store: StoreOf<ExampleFeature>) {
    self.store = store
  }

  @Environment(\.designSpacing) var spacing
  @Environment(\.designFonts) var fonts

  public var body: some View {
    VStack(spacing: spacing.lg) {
      Text("\(store.counter)")
        .font(fonts.hero)
        .monospacedDigit()

      HStack(spacing: spacing.md) {
        Button("−") { send(.decrementButtonTapped) }
          .buttonStyle(.secondary)
        Button("+") { send(.incrementButtonTapped) }
          .buttonStyle(.primary)
      }

      Button(DesignSystemStrings.resetButton) { send(.resetButtonTapped) }
        .buttonStyle(.secondary)
    }
    .padding()
    .navigationTitle(DesignSystemStrings.exampleTitle)
  }
}

#if DEBUG
  #Preview {
    NavigationStack {
      ExampleView(
        store: Store(initialState: ExampleFeature.State(counter: 3)) {
          ExampleFeature()
        }
      )
    }
  }
#endif
