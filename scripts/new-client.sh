#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-${NAME:-}}"
if [ -z "$BASE" ]; then
  echo "Usage: make client NAME=Location"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$SCRIPT_DIR/.."
PROJECT_FILE="$APP_DIR/Project.swift"
HELPERS_FILE="$APP_DIR/Tuist/ProjectDescriptionHelpers/TargetDependency+Named.swift"
FEATURE_MARKER="// tuist-marker: insert new features above this line"
DEPS_MARKER="// tuist-marker: insert new client deps above this line"

CLIENT="${BASE}Client"
KEY="$(echo "${BASE:0:1}" | tr '[:upper:]' '[:lower:]')${BASE:1}Client"
SOURCES="$APP_DIR/Features/$CLIENT/Sources"
TESTS="$APP_DIR/Features/$CLIENT/Tests"

if [ -d "$APP_DIR/Features/$CLIENT" ]; then
  echo "✗ '$CLIENT' already exists at Features/$CLIENT"
  exit 1
fi

if ! grep -qF "$FEATURE_MARKER" "$PROJECT_FILE"; then
  echo "✗ marker not found in Project.swift: $FEATURE_MARKER"
  exit 1
fi

if ! grep -qF "$DEPS_MARKER" "$HELPERS_FILE"; then
  echo "✗ marker not found in Project+Templates.swift: $DEPS_MARKER"
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

# ── Insert into Project+Templates.swift (TargetDependency extension) ──────────

DEP_LINE="  static let $KEY: Self = .target(name: \"$CLIENT\")"
awk -v insert="$DEP_LINE" -v marker="$DEPS_MARKER" '
  index($0, marker) { print insert }
  { print }
' "$HELPERS_FILE" > "$HELPERS_FILE.tmp" && mv "$HELPERS_FILE.tmp" "$HELPERS_FILE"

# ── Insert into Project.swift (features array) ────────────────────────────────

FEATURE_LINE="  FeatureTargetBuilder(\"$CLIENT\", dependencies: [.composableArchitecture]),"
awk -v insert="$FEATURE_LINE" -v marker="$FEATURE_MARKER" '
  index($0, marker) { print insert }
  { print }
' "$PROJECT_FILE" > "$PROJECT_FILE.tmp" && mv "$PROJECT_FILE.tmp" "$PROJECT_FILE"

# ── Done ──────────────────────────────────────────────────────────────────────

echo "✓ Created $CLIENT"
echo "✓ Wired into Project.swift + Project+Templates.swift (.$KEY)"
echo ""
echo "  Add to dependents:"
echo "    dependencies: [..., .$KEY]"
echo ""
echo "  Run: make"
