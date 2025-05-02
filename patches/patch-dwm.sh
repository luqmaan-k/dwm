#!/bin/bash

# Get the directory where this script is located (i.e., dwm/patches)
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Get the root of the dwm repository (one level up from the patches directory)
REPO_ROOT=$(realpath "$SCRIPT_DIR/..")

# Check if we are inside the dwm source directory
if [ ! -d "$REPO_ROOT" ]; then
    echo "Error: The script should reside in the dwm/patches directory, and it should apply patches to the dwm source."
    exit 1
fi

# List of patches to apply (relative to the dwm/patches directory)
PATCHES=(
    "$SCRIPT_DIR/dwm-status2d-systray-6.4.diff"  # Add all your patch files here
)

# Change to the root of the dwm repository
cd "$REPO_ROOT" || exit 1

# Apply patches in order
echo "Applying patches..."
for PATCH in "${PATCHES[@]}"; do
    if [ ! -f "$PATCH" ]; then
        echo "Error: Patch file $PATCH not found."
        exit 1
    fi
    echo "Applying $PATCH..."
    patch -p1 < "$PATCH" || exit 1
done

# Run dwm-update.sh to apply the changes
echo "Patches applied successfully. Running dwm-update.sh..."
./dwm-update.sh

echo "DWM updated successfully."

