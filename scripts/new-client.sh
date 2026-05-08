#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-${NAME:-}}"
if [ -z "$BASE" ]; then
  echo "Usage: make client NAME=Location"
  exit 1
fi

CLIENT="${BASE}Client"
KEY="$(echo "${BASE:0:1}" | tr '[:upper:]' '[:lower:]')${BASE:1}Client"
SOURCES="Features/$CLIENT/Sources"
TESTS="Features/$CLIENT/Tests"

if [ -d "Features/$CLIENT" ]; then
  echo "✗ '$CLIENT' already exists at Features/$CLIENT"
  exit 1
fi

mkdir -p "$SOURCES" "$TESTS"

# ── Interface ─────────────────────────────────────────────────────────────────

cat > "$SOURCES/Interface.swift" << 'SWIFTEOF'
import ComposableArchitecture

@DependencyClient
public struct CLIENT_NAME: Sendable {
  // Define your endpoints here:
  // public var fetchSomething: @Sendable () async throws -> String
}
SWIFTEOF

# ── LiveKey ───────────────────────────────────────────────────────────────────

cat > "$SOURCES/LiveKey.swift" << 'SWIFTEOF'
import Dependencies

extension CLIENT_NAME: DependencyKey {
  public static var liveValue: Self {
    // Use @Dependency(\.otherClient) here if this client depends on another
    Self(
      // Implement live endpoints here
    )
  }
}
SWIFTEOF

# ── TestKey ───────────────────────────────────────────────────────────────────

cat > "$SOURCES/TestKey.swift" << 'SWIFTEOF'
import Dependencies

extension DependencyValues {
  public var CLIENT_KEY: CLIENT_NAME {
    get { self[CLIENT_NAME.self] }
    set { self[CLIENT_NAME.self] = newValue }
  }
}

extension CLIENT_NAME: TestDependencyKey {
  public static let testValue = Self()
  public static let previewValue = Self.noop
}

extension CLIENT_NAME {
  public static let noop = Self(
    // No-op implementations here
  )
}
SWIFTEOF

# ── Tests ─────────────────────────────────────────────────────────────────────

cat > "$TESTS/${CLIENT}Tests.swift" << 'SWIFTEOF'
import ComposableArchitecture
import Testing

@testable import CLIENT_NAME

@Suite("CLIENT_NAME")
struct CLIENT_NAMETests {
  @Test("preview value does not throw")
  func previewValue() async {
    // Verify previewValue endpoints are callable
  }
}
SWIFTEOF

# ── Replace placeholders ──────────────────────────────────────────────────────

sed -i '' "s/CLIENT_NAME/$CLIENT/g" "$SOURCES/Interface.swift"
sed -i '' "s/CLIENT_NAME/$CLIENT/g" "$SOURCES/LiveKey.swift"
sed -i '' "s/CLIENT_NAME/$CLIENT/g" "$SOURCES/TestKey.swift"
sed -i '' "s/CLIENT_KEY/$KEY/g"     "$SOURCES/TestKey.swift"
sed -i '' "s/CLIENT_NAME/$CLIENT/g" "$TESTS/${CLIENT}Tests.swift"

# ── Done ──────────────────────────────────────────────────────────────────────

echo "✓ Created $CLIENT"
echo ""
echo "1. Add to Project+Templates.swift:"
echo "   static let $KEY: Self = .target(name: \"$CLIENT\")"
echo ""
echo "2. Add to Project.swift features array:"
echo "   FeatureTargetBuilder(\"$CLIENT\", dependencies: [.composableArchitecture]),"
echo ""
echo "3. Add to dependents:"
echo "   dependencies: [..., .$KEY]"
echo ""
echo "4. Run: make generate"
