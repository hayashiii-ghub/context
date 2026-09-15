#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$ROOT_DIR/script/app_bundle.sh"
source "$ROOT_DIR/script/sparkle.sh"

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/context-app-bundle-test.XXXXXX")"
trap 'rm -rf "$TMP_DIR"' EXIT

INFO_PLIST="$TMP_DIR/Info.plist"
context_write_info_plist "$INFO_PLIST" "1.2.3"

test "$(plutil -extract CFBundleShortVersionString raw "$INFO_PLIST")" = "1.2.3"
test "$(plutil -extract SUFeedURL raw "$INFO_PLIST")" = "$CONTEXT_SPARKLE_FEED_URL"
test "$(plutil -extract SUPublicEDKey raw "$INFO_PLIST")" = "$CONTEXT_SPARKLE_PUBLIC_ED_KEY"
test "$(plutil -extract SUEnableAutomaticChecks raw "$INFO_PLIST")" = "true"

SPARKLE_FRAMEWORK="$(context_sparkle_framework_path "$ROOT_DIR")"
test -x "$SPARKLE_FRAMEWORK/Sparkle"
test -d "$SPARKLE_FRAMEWORK/Updater.app"
test -x "$(context_sparkle_bin_dir "$ROOT_DIR")/generate_appcast"

APP_BUNDLE="$TMP_DIR/Context.app"
APP_MACOS="$APP_BUNDLE/Contents/MacOS"
APP_BINARY="$APP_MACOS/Context"
BUILD_BINARY="$(cd "$ROOT_DIR" && swift build --show-bin-path)/Context"
test -x "$BUILD_BINARY"
mkdir -p "$APP_MACOS"
cp "$BUILD_BINARY" "$APP_BINARY"
context_embed_sparkle "$ROOT_DIR" "$APP_BUNDLE" "$APP_BINARY"
context_write_info_plist "$APP_BUNDLE/Contents/Info.plist" "1.2.3"
test -d "$APP_BUNDLE/Contents/Frameworks/Sparkle.framework"
context_binary_has_rpath "$APP_BINARY" "@executable_path/../Frameworks"
codesign --force --sign - "$APP_BUNDLE"
codesign --verify --deep --strict "$APP_BUNDLE"
