#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/context-install-test.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT

INSTALL_DIR="$TEST_ROOT/Applications"
EXISTING_APP="$INSTALL_DIR/Context.app"
mkdir -p "$EXISTING_APP/Contents"
printf 'keep-existing\n' >"$EXISTING_APP/Contents/existing-marker"

INVALID_ROOT="$TEST_ROOT/invalid"
mkdir -p "$INVALID_ROOT/Context.app/Contents"
printf 'invalid\n' >"$INVALID_ROOT/Context.app/Contents/payload"
ditto -c -k --keepParent "$INVALID_ROOT/Context.app" "$TEST_ROOT/invalid.zip"

if CONTEXT_INSTALL_DIR="$INSTALL_DIR" \
    CONTEXT_ZIP_PATH="$TEST_ROOT/invalid.zip" \
    CONTEXT_SKIP_STOP=1 \
    CONTEXT_SKIP_OPEN=1 \
    "$ROOT_DIR/script/install_latest.sh"; then
  echo "invalid app archive was accepted" >&2
  exit 1
fi

test -f "$EXISTING_APP/Contents/existing-marker"

VALID_ROOT="$TEST_ROOT/valid"
VALID_APP="$VALID_ROOT/Context.app"
mkdir -p "$VALID_APP/Contents/MacOS"
cat >"$VALID_APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>Context</string>
  <key>CFBundleIdentifier</key><string>work.hayashigoto.Context</string>
  <key>CFBundleShortVersionString</key><string>9.9.9</string>
  <key>CFBundleVersion</key><string>9.9.9</string>
  <key>CFBundlePackageType</key><string>APPL</string>
</dict></plist>
PLIST
cat >"$VALID_APP/Contents/MacOS/Context" <<'EXECUTABLE'
#!/usr/bin/env bash
exit 0
EXECUTABLE
chmod +x "$VALID_APP/Contents/MacOS/Context"
codesign --force --sign - "$VALID_APP"
ditto -c -k --keepParent "$VALID_APP" "$TEST_ROOT/valid.zip"

CONTEXT_INSTALL_DIR="$INSTALL_DIR" \
  CONTEXT_ZIP_PATH="$TEST_ROOT/valid.zip" \
  CONTEXT_SKIP_STOP=1 \
  CONTEXT_SKIP_OPEN=1 \
  "$ROOT_DIR/script/install_latest.sh"

INSTALLED_APP="$INSTALL_DIR/Context.app"
test "$(plutil -extract CFBundleShortVersionString raw "$INSTALLED_APP/Contents/Info.plist")" = "9.9.9"
codesign --verify --deep --strict "$INSTALLED_APP"

PIPED_INSTALL_DIR="$TEST_ROOT/PipedApplications"
mkdir -p "$PIPED_INSTALL_DIR"
CONTEXT_INSTALL_DIR="$PIPED_INSTALL_DIR" \
  CONTEXT_ZIP_PATH="$TEST_ROOT/valid.zip" \
  CONTEXT_SKIP_STOP=1 \
  CONTEXT_SKIP_OPEN=1 \
  bash < "$ROOT_DIR/script/install_latest.sh"

test -x "$PIPED_INSTALL_DIR/Context.app/Contents/MacOS/Context"
codesign --verify --deep --strict "$PIPED_INSTALL_DIR/Context.app"
