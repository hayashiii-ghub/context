#!/usr/bin/env bash

CONTEXT_APP_NAME="Context"
CONTEXT_BUNDLE_ID="work.hayashigoto.Context"
CONTEXT_MIN_SYSTEM_VERSION="26.0"

context_copy_bundle_resources() {
  local root_dir="$1"
  local resources_dir="$2"

  cp "$root_dir/Assets/Context.icns" "$resources_dir/Context.icns"
  cp "$root_dir/Assets/MenuBarTemplate.svg" "$resources_dir/MenuBarTemplate.svg"
}

context_write_info_plist() {
  local info_plist="$1"
  local app_version="$2"

  cat >"$info_plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>$CONTEXT_APP_NAME</string>
  <key>CFBundleIdentifier</key>
  <string>$CONTEXT_BUNDLE_ID</string>
  <key>CFBundleName</key>
  <string>$CONTEXT_APP_NAME</string>
  <key>CFBundleDisplayName</key>
  <string>$CONTEXT_APP_NAME</string>
  <key>CFBundleIconFile</key>
  <string>Context.icns</string>
  <key>CFBundleShortVersionString</key>
  <string>$app_version</string>
  <key>CFBundleVersion</key>
  <string>$app_version</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>LSMinimumSystemVersion</key>
  <string>$CONTEXT_MIN_SYSTEM_VERSION</string>
  <key>NSHighResolutionCapable</key>
  <true/>
  <key>NSAppleEventsUsageDescription</key>
  <string>Context uses Finder access to add your selected files to the shelf.</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSPrincipalClass</key>
  <string>NSApplication</string>
</dict>
</plist>
PLIST
}
