#!/usr/bin/env bash
set -euo pipefail

# Determine the directory this script resides in (patches/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_DIR="$SCRIPT_DIR"

# Ensure patch name is passed
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 dwm-patchname-version"
  echo "Example: $0 dwm-status2d-6.3"
  exit 1
fi

PATCH_NAME="$1"
PATCH_FILE="${PATCH_NAME}"
PATCH_BASE="$(echo "$PATCH_NAME" | cut -d'-' -f2)"

# Construct the URL
URL="https://dwm.suckless.org/patches/${PATCH_BASE}/${PATCH_FILE}"

# Download the patch
echo "Downloading $PATCH_FILE from $URL..."
curl -fLo "${PATCH_DIR}/${PATCH_FILE}" "$URL"

echo "Saved to ${PATCH_DIR}/${PATCH_FILE}"

