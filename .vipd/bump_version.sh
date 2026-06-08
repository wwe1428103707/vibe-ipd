#!/usr/bin/env bash
# bump_version.sh — Bump vipd_version in .vipd/version.yml
# Usage: .vipd/bump_version.sh [major|minor|patch]
# Updates vipd_version only; speckit_version is unchanged.

set -euo pipefail

VERSION_FILE="$(cd "$(dirname "$0")" && pwd)/version.yml"

if [ ! -f "$VERSION_FILE" ]; then
  echo "Error: $VERSION_FILE not found" >&2
  exit 1
fi

BUMP_TYPE="${1:-patch}"
CURRENT=$(grep '^vipd_version:' "$VERSION_FILE" | awk '{print $2}' | tr -d '"')

if [ -z "$CURRENT" ]; then
  echo "Error: Could not read vipd_version from $VERSION_FILE" >&2
  exit 1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"
# Strip pre-release suffix if present
PATCH="${PATCH%%-*}"

case "$BUMP_TYPE" in
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
    echo "Usage: $0 [major|minor|patch]" >&2
    exit 1
    ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"

# Update the version file
if [[ "$(uname -s)" == "Darwin" ]]; then
  sed -i '' "s/^vipd_version:.*/vipd_version: \"$NEW_VERSION\"/" "$VERSION_FILE"
else
  sed -i "s/^vipd_version:.*/vipd_version: \"$NEW_VERSION\"/" "$VERSION_FILE"
fi

echo "vipd $CURRENT → $NEW_VERSION"
