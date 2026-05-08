#!/usr/bin/env bash
set -euo pipefail

TUIST_VERSION=$(cat "$(dirname "$0")/../.tuist-version" | tr -d '[:space:]')
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/../.tuist-bin"
mkdir -p "$BIN_DIR"
BIN_DIR="$(cd "$BIN_DIR" && pwd)"
TUIST_BIN="$BIN_DIR/tuist"

check_version() {
    "$1" version 2>/dev/null | tr -d '[:space:]'
}

# Already installed with correct version
if [ -f "$TUIST_BIN" ] && [ "$(check_version "$TUIST_BIN")" = "$TUIST_VERSION" ]; then
    echo "✓ Tuist $TUIST_VERSION already in .tuist-bin/"
    exit 0
fi

# Try direct GitHub download first
DOWNLOAD_URL="https://github.com/tuist/tuist/releases/download/$TUIST_VERSION/tuist.zip"
TMP_ZIP="/tmp/tuist-$TUIST_VERSION.zip"

echo "→ Attempting download of Tuist $TUIST_VERSION..."
if curl -fsSL --max-time 30 "$DOWNLOAD_URL" -o "$TMP_ZIP" 2>/dev/null; then
    unzip -q -o "$TMP_ZIP" -d "$BIN_DIR"
    chmod +x "$TUIST_BIN"
    rm -f "$TMP_ZIP"
    echo "✓ Tuist $TUIST_VERSION installed to .tuist-bin/"
    exit 0
fi

echo "→ Direct download unavailable (Tuist 4.x uses mise for distribution)."

# Fall back to global tuist if version matches
if command -v tuist &>/dev/null; then
    GLOBAL_VERSION=$(check_version tuist)
    if [ "$GLOBAL_VERSION" = "$TUIST_VERSION" ]; then
        cp "$(which tuist)" "$TUIST_BIN"
        echo "✓ Copied global Tuist $TUIST_VERSION to .tuist-bin/"
        exit 0
    else
        echo "  Global Tuist is $GLOBAL_VERSION, need $TUIST_VERSION."
    fi
fi

echo ""
echo "✗ Could not install Tuist $TUIST_VERSION locally."
echo "  Options:"
echo "  1. Install via mise:    brew install mise && mise install tuist@$TUIST_VERSION"
echo "  2. Use global tuist:    update .tuist-version to match your installed version"
echo "  3. Install via brew:    brew install tuist"
exit 1
