#!/usr/bin/env bash
set -euo pipefail

BASE="${1:-${NAME:-}}"
WITH_CLIENT="${WITH_CLIENT:-}"

if [ -z "$BASE" ]; then
  echo "Usage: make feature NAME=Settings [WITH_CLIENT=Settings]"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$SCRIPT_DIR/.."
PROJECT_FILE="$APP_DIR/Project.swift"
FEATURE_MARKER="// tuist-marker: insert new features above this line"

FEATURE="${BASE}Feature"
VIEW="${BASE}View"
SOURCES="$APP_DIR/Features/$FEATURE/Sources"
TESTS="$APP_DIR/Features/$FEATURE/Tests"

if [ -d "$APP_DIR/Features/$FEATURE" ]; then
  echo "✗ '$FEATURE' already exists at Features/$FEATURE"
  exit 1
fi

if ! grep -qF "$FEATURE_MARKER" "$PROJECT_FILE"; then
  echo "✗ marker not found in Project.swift"
  echo "  Expected: $FEATURE_MARKER"
  echo "  inside the 'features' array, just before its closing ']'."
  exit 1
fi

# ── Optional paired client ────────────────────────────────────────────────────

CLIENT_DEP_TOKEN=""
if [ -n "$WITH_CLIENT" ]; then
  echo "→ Scaffolding paired client: ${WITH_CLIENT}Client"
  bash "$SCRIPT_DIR/new-client.sh" "$WITH_CLIENT"
  # Lower-camel form, matches new-client.sh's KEY logic:
  CLIENT_DEP_TOKEN=", .$(echo "${WITH_CLIENT:0:1}" | tr '[:upper:]' '[:lower:]')${WITH_CLIENT:1}Client"
fi

mkdir -p "$SOURCES" "$TESTS"

# ── Reducer ───────────────────────────────────────────────────────────────────

cat > "$SOURCES/$FEATURE.swift" << 'SWIFTEOF'
import ComposableArchitecture

@Reducer
public struct FEATURE_NAME {

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action: ViewAction {
    case view(View)
    case delegate(Delegate)

    @CasePathable
    public enum View {
      case onAppear
    }

    @CasePathable
    public enum Delegate: Equatable {}
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { _, action in
      switch action {
      case .view(.onAppear):
        return .none
      case .delegate:
        return .none
      }
    }
  }
}
SWIFTEOF

# ── View ──────────────────────────────────────────────────────────────────────

cat > "$SOURCES/$VIEW.swift" << 'SWIFTEOF'
import ComposableArchitecture
import DesignSystem
import SwiftUI

@ViewAction(for: FEATURE_NAME.self)
public struct VIEW_NAME: View {
  public let store: StoreOf<FEATURE_NAME>

  public init(store: StoreOf<FEATURE_NAME>) {
    self.store = store
  }

  @Environment(\.designSpacing) var spacing

  public var body: some View {
    Text("FEATURE_NAME")
      .onAppear { send(.onAppear) }
  }
}

#if DEBUG
#Preview {
  VIEW_NAME(
    store: Store(initialState: FEATURE_NAME.State()) {
      FEATURE_NAME()
    }
  )
}
#endif
SWIFTEOF

# ── Reducer tests ─────────────────────────────────────────────────────────────

cat > "$TESTS/${FEATURE}Tests.swift" << 'SWIFTEOF'
import ComposableArchitecture
import Testing

@testable import FEATURE_NAME

@Suite("FEATURE_NAME")
@MainActor
struct FEATURE_NAMETests {
  private func makeStore(
    initialState: FEATURE_NAME.State = .init(),
    dependencies: (inout DependencyValues) -> Void = { _ in }
  ) -> TestStoreOf<FEATURE_NAME> {
    TestStore(initialState: initialState) {
      FEATURE_NAME()
    } withDependencies: {
      dependencies(&$0)
    }
  }

  @Test("onAppear produces no state change")
  func onAppear() async {
    let store = makeStore()
    await store.send(.view(.onAppear))
  }
}
SWIFTEOF

# ── View snapshot tests ───────────────────────────────────────────────────────

cat > "$TESTS/${VIEW}Tests.swift" << 'SWIFTEOF'
import ComposableArchitecture
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@testable import FEATURE_NAME

@Suite("VIEW_NAME", .serialized)
@MainActor
struct VIEW_NAMETests {
  private func makeViewController(
    userInterfaceStyle: UIUserInterfaceStyle = .light
  ) -> UIViewController {
    let controller = UIHostingController(
      rootView: VIEW_NAME(
        store: Store(initialState: FEATURE_NAME.State()) {
          FEATURE_NAME()
        }
      )
    )
    controller.overrideUserInterfaceStyle = userInterfaceStyle
    return controller
  }

  @Test("light mode")
  func lightMode() {
    assertSnapshot(of: makeViewController(), as: .image(on: .iPhone13Pro))
  }

  @Test("dark mode")
  func darkMode() {
    assertSnapshot(of: makeViewController(userInterfaceStyle: .dark), as: .image(on: .iPhone13Pro))
  }
}
SWIFTEOF

# ── Replace placeholders ──────────────────────────────────────────────────────

sed -i '' "s/FEATURE_NAME/$FEATURE/g" "$SOURCES/$FEATURE.swift"
sed -i '' "s/FEATURE_NAME/$FEATURE/g" "$SOURCES/$VIEW.swift"
sed -i '' "s/VIEW_NAME/$VIEW/g"       "$SOURCES/$VIEW.swift"
sed -i '' "s/FEATURE_NAME/$FEATURE/g" "$TESTS/${FEATURE}Tests.swift"
sed -i '' "s/FEATURE_NAME/$FEATURE/g" "$TESTS/${VIEW}Tests.swift"
sed -i '' "s/VIEW_NAME/$VIEW/g"       "$TESTS/${VIEW}Tests.swift"

# ── Insert into Project.swift (above marker) ──────────────────────────────────

NEW_LINE="  FeatureTargetBuilder(\"$FEATURE\", dependencies: [.composableArchitecture, .designSystem${CLIENT_DEP_TOKEN}]),"

awk -v insert="$NEW_LINE" -v marker="$FEATURE_MARKER" '
  index($0, marker) { print insert }
  { print }
' "$PROJECT_FILE" > "$PROJECT_FILE.tmp" && mv "$PROJECT_FILE.tmp" "$PROJECT_FILE"

# ── Done ──────────────────────────────────────────────────────────────────────

echo "✓ Created $FEATURE"
echo "✓ Wired into Project.swift"
if [ -n "$WITH_CLIENT" ]; then
  echo "✓ Linked ${WITH_CLIENT}Client as dependency"
fi
echo ""
echo "  Run: make"
