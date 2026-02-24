#!/usr/bin/env bash
# Bump the version number
# Usage: ./scripts/bump-version.sh [major|minor|patch]

set -euo pipefail

BUMP_TYPE="${1:-patch}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
VERSION_FILE="${PROJECT_ROOT}/VERSION"

if [ ! -f "${VERSION_FILE}" ]; then
    echo "Error: VERSION file not found at ${VERSION_FILE}"
    exit 1
fi

# Read current version
CURRENT_VERSION=$(cat "${VERSION_FILE}")
echo "Current version: ${CURRENT_VERSION}"

# Parse version components
IFS='.' read -r -a parts <<< "${CURRENT_VERSION}"
MAJOR="${parts[0]}"
MINOR="${parts[1]}"
PATCH="${parts[2]}"

# Bump version based on type
case "${BUMP_TYPE}" in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "Error: Invalid bump type '${BUMP_TYPE}'"
        echo "Usage: $0 [major|minor|patch]"
        exit 1
        ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "New version: ${NEW_VERSION}"

# Write new version
echo "${NEW_VERSION}" > "${VERSION_FILE}"
echo "✓ Updated VERSION file"

# Check if we're in a git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    echo ""
    echo "Git repository detected. You can commit this change with:"
    echo ""
    echo "  git add VERSION"
    echo "  git commit -m \"Bump version to ${NEW_VERSION}\""
    echo "  git tag -a \"v${NEW_VERSION}\" -m \"Release v${NEW_VERSION}\""
    echo "  git push origin main --tags"
fi
