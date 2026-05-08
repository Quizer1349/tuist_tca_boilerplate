import SwiftUI

public extension Color {
  /// Initialize a Color from a hex string. Designed for Figma copy-paste workflows.
  ///
  /// Supports:
  /// - `#RGB`       (3-digit shorthand, alpha = 1)
  /// - `#RRGGBB`    (alpha = 1)
  /// - `#AARRGGBB`  (leading alpha)
  ///
  /// The leading `#` is optional. Whitespace and case are ignored.
  /// Reserve hex for brand/Figma-parity colors. Use asset-catalog colors
  /// for system-semantic adaptation (dark mode, high contrast).
  ///
  /// On parse failure: magenta in DEBUG (visible in Preview), `.clear` in release.
  init(hex: String, opacity overrideOpacity: Double? = nil) {
    self = Color.parseHex(hex, overrideOpacity: overrideOpacity) ?? Color.hexFallback
  }

  private static func parseHex(_ hex: String, overrideOpacity: Double?) -> Color? {
    var value = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if value.hasPrefix("#") {
      value.removeFirst()
    }

    let red, green, blue, alpha: Double

    switch value.count {
    case 3:
      let expanded = String(value.flatMap { [$0, $0] })
      guard let raw = UInt64(expanded, radix: 16) else { return nil }
      alpha = 1
      red = Double((raw >> 16) & 0xFF) / 255
      green = Double((raw >> 8) & 0xFF) / 255
      blue = Double(raw & 0xFF) / 255

    case 6:
      guard let raw = UInt64(value, radix: 16) else { return nil }
      alpha = 1
      red = Double((raw >> 16) & 0xFF) / 255
      green = Double((raw >> 8) & 0xFF) / 255
      blue = Double(raw & 0xFF) / 255

    case 8:
      guard let raw = UInt64(value, radix: 16) else { return nil }
      alpha = Double((raw >> 24) & 0xFF) / 255
      red = Double((raw >> 16) & 0xFF) / 255
      green = Double((raw >> 8) & 0xFF) / 255
      blue = Double(raw & 0xFF) / 255

    default:
      return nil
    }

    return Color(red: red, green: green, blue: blue, opacity: overrideOpacity ?? alpha)
  }

  private static var hexFallback: Color {
    #if DEBUG
      Color(red: 1, green: 0, blue: 1)
    #else
      .clear
    #endif
  }
}
