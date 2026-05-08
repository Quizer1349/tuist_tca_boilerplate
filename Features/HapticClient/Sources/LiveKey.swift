import Dependencies
import UIKit

extension HapticClient: DependencyKey {
  public static var liveValue: Self {
    Self(
      play: { @MainActor event in
        switch event {
        case .selection:
          UISelectionFeedbackGenerator().selectionChanged()
        case .success:
          UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
          UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .error:
          UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .lightTap:
          UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .mediumTap:
          UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavyTap:
          UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
      }
    )
  }
}
