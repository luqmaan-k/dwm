#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# patch-dwm.sh
#  - Place this script in your dwm/patches/ folder alongside your *.diff files
#  - It will apply patches in a fixed, reliable order, then rebuild & install.
# -----------------------------------------------------------------------------

# Resolve the script & repo directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# Go to the dwm source root
cd "$REPO_DIR"

# Clean out any previous build artifacts
echo "🧹 Cleaning previous build…"
make clean

# Define your patches in the precise order they must be applied:
patches=(
  dwm-status2d-systray-6.4.diff
)

echo "📦 Applying patches in order:"
for p in "${patches[@]}"; do
  patch_file="$SCRIPT_DIR/$p"
  if [[ ! -f "$patch_file" ]]; then
    echo "⚠️  Warning: Patch not found: $p — skipping."
    continue
  fi

  echo "→ $p"
  # -N: ignore already applied hunks
  # -p1: strip leading slash from file paths in diff
  patch -N -p1 < "$patch_file" || {
    echo "❌ Failed to apply $p"
    exit 1
  }
done

# Rebuild and install
echo "🛠 Rebuilding dwm…"
make

echo "🚀 Installing dwm (PREFIX=\${PREFIX:-\$HOME/.local})…"
make install PREFIX="${PREFIX:-$HOME/.local}"

echo "✅ All patches applied and dwm installed."
echo "   Restart or reload dwm to see your patched setup."

