#!/usr/bin/env bash
set -euo pipefail

# Resolve directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

cd "$REPO_DIR" || exit 1

echo "Cleaning old build..."
make clean

echo "Applying patches from $SCRIPT_DIR..."
for patch in "$SCRIPT_DIR"/*.diff; do
  echo "→ Applying $(basename "$patch")"
  patch -N -p1 < "$patch" || {
    echo "✗ Failed to apply $(basename "$patch")"
    exit 1
  }
done

echo "Rebuilding DWM..."
make
sudo make install

echo "Patching complete. Restart DWM to apply changes."

