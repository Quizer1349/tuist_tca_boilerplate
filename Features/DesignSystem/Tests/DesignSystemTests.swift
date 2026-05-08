@testable import DesignSystem
import Testing

@Suite("DesignSystem")
struct DesignSystemTests {
  @Test("Spacing scale is ordered smallest to largest")
  func spacingScale() {
    let spacing = DesignSpacing.default
    #expect(spacing.xs < spacing.sm)
    #expect(spacing.sm < spacing.md)
    #expect(spacing.md < spacing.lg)
    #expect(spacing.lg < spacing.xl)
  }

  @Test("Radius scale is ordered small to large with pill on top")
  func radiusScale() {
    let radius = DesignRadius.default
    #expect(radius.small < radius.medium)
    #expect(radius.medium < radius.large)
    #expect(radius.large < radius.pill)
  }
}
