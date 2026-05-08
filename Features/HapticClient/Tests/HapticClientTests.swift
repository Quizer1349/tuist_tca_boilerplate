import ComposableArchitecture
@testable import HapticClient
import Testing

@Suite("HapticClient")
struct HapticClientTests {
  @Test("noop play does not throw for any event")
  func noopPlay() async {
    let events: [HapticEvent] = [
      .selection, .success, .warning, .error,
      .lightTap, .mediumTap, .heavyTap,
    ]
    for event in events {
      await HapticClient.noop.play(event)
    }
  }
}
