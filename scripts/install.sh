#!/usr/bin/env bash
# Browser Switch – install from source
# https://github.com/adamabernathy/browser-selector
#
# One-liner install (copy and paste into Terminal):
#
#   curl -fsSL https://raw.githubusercontent.com/adamabernathy/browser-selector/main/scripts/install.sh | bash
#
# Requirements: Xcode or Xcode Command Line Tools with Swift 5.9+

set -euo pipefail

REPO_URL="https://github.com/adamabernathy/browser-selector"
APP_NAME="Browser Switch"
INSTALL_DIR="${HOME}/Applications"

# Detect whether we're inside a repo checkout or running standalone (e.g., curl | bash).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""

if [ -n "${SCRIPT_DIR}" ] && [ -f "${SCRIPT_DIR}/../Package.swift" ]; then
    PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
else
    PROJECT_DIR="$(mktemp -d)"
    trap 'rm -rf "${PROJECT_DIR}"' EXIT
    echo "Cloning ${REPO_URL}..."
    git clone --depth 1 --quiet "${REPO_URL}" "${PROJECT_DIR}"
fi

cd "${PROJECT_DIR}"

# Read version if available
if [ -f "VERSION" ]; then
    VERSION=$(cat VERSION)
    echo "Building ${APP_NAME} v${VERSION}..."
else
    echo "Building ${APP_NAME}..."
fi

./scripts/build-app.sh --release

mkdir -p "${INSTALL_DIR}"

if [ -d "${INSTALL_DIR}/${APP_NAME}.app" ]; then
    echo "Removing previous install..."
    rm -rf "${INSTALL_DIR}/${APP_NAME}.app"
fi

cp -R "dist/${APP_NAME}.app" "${INSTALL_DIR}/${APP_NAME}.app"
echo "Installed to ${INSTALL_DIR}/${APP_NAME}.app"
echo "Launching ${APP_NAME}..."
open "${INSTALL_DIR}/${APP_NAME}.app"
