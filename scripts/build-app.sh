#!/usr/bin/env bash
set -euo pipefail

APP_NAME="Browser Switch"
PRODUCT_NAME="BrowserSwitchMenuBarApp"
BUNDLE_ID="com.adamabernathy.browserswitch"
VERSION="1.0"
BUILD_CONFIG="release"
DIST_DIR="dist"
APP_DIR="${DIST_DIR}/${APP_NAME}.app"
EXECUTABLE_PATH="${APP_DIR}/Contents/MacOS/${APP_NAME}"
RUN_AFTER_BUILD=0

# Detect build version (commit hash or LOCAL BUILD)
if git rev-parse --git-dir > /dev/null 2>&1; then
  BUILD_VERSION=$(git rev-parse --short HEAD 2>/dev/null || echo "LOCAL BUILD")
else
  BUILD_VERSION="LOCAL BUILD"
fi

# Prefer the full Xcode toolchain when available.
if [[ -z "${DEVELOPER_DIR:-}" && -d "/Applications/Xcode.app/Contents/Developer" ]]; then
  export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
fi

# Keep module cache in a writable location for sandboxed/dev environments.
export CLANG_MODULE_CACHE_PATH="${CLANG_MODULE_CACHE_PATH:-/tmp/swift-module-cache}"
export SWIFT_MODULECACHE_PATH="${SWIFT_MODULECACHE_PATH:-/tmp/swift-module-cache}"
mkdir -p "${CLANG_MODULE_CACHE_PATH}"
mkdir -p "${SWIFT_MODULECACHE_PATH}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      BUILD_CONFIG="debug"
      shift
      ;;
    --release)
      BUILD_CONFIG="release"
      shift
      ;;
    --run)
      RUN_AFTER_BUILD=1
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--debug|--release] [--run]"
      exit 1
      ;;
  esac
done

xcrun swift build -c "${BUILD_CONFIG}"

mkdir -p "${APP_DIR}/Contents/MacOS"
mkdir -p "${APP_DIR}/Contents/Resources"

cp ".build/${BUILD_CONFIG}/${PRODUCT_NAME}" "${EXECUTABLE_PATH}"
chmod +x "${EXECUTABLE_PATH}"

cat > "${APP_DIR}/Contents/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleDevelopmentRegion</key>
  <string>en</string>
  <key>CFBundleExecutable</key>
  <string>${APP_NAME}</string>
  <key>CFBundleIdentifier</key>
  <string>${BUNDLE_ID}</string>
  <key>CFBundleInfoDictionaryVersion</key>
  <string>6.0</string>
  <key>CFBundleName</key>
  <string>${APP_NAME}</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>${VERSION}</string>
  <key>CFBundleVersion</key>
  <string>${BUILD_VERSION}</string>
  <key>LSMinimumSystemVersion</key>
  <string>12.0</string>
  <key>LSUIElement</key>
  <true/>
  <key>NSHighResolutionCapable</key>
  <true/>
</dict>
</plist>
PLIST

echo "Built app bundle at: ${APP_DIR}"

if [[ "${RUN_AFTER_BUILD}" -eq 1 ]]; then
  open "${APP_DIR}"
fi
