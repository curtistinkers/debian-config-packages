#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
TARGET_DIR="$1"
OUTPUT_DIR="$(pwd)/dist"

# --- Validation ---
if [ -z "${TARGET_DIR}" ]; then
    echo "Error: Please provide a directory name."
    echo "Usage: $0 <directory_name>"
    exit 1
fi

if [ ! -d "${TARGET_DIR}" ]; then
    echo "Error: Directory '${TARGET_DIR}' does not exist."
    exit 1
fi

# --- Main Logic ---
echo "Starting build process for: ${TARGET_DIR}"

# Create output directory for binaries if it doesn't exist
mkdir -p "${OUTPUT_DIR}"

# Navigate into the package directory
cd "${TARGET_DIR}"

# Ensure it is a valid Debian source directory
if [ ! -d "debian" ]; then
    echo "Error: '${TARGET_DIR}' is not a valid Debian package directory (missing 'debian/' folder)."
    exit 1
fi

# Run debuild to create binary package (-b) without signing changes/dsc (-us -uc)
echo "Running debuild..."
debuild -b -us -uc

# Navigate back to the parent directory to handle artifacts and cleanup
cd ..

echo "Moving .deb artifact to ${OUTPUT_DIR}..."
# Move .deb files, changes, and buildinfo files generated in the parent directory
# Using || true ensures the script doesn't crash if a specific extension isn't generated
mv "${TARGET_DIR}"_*.deb "${OUTPUT_DIR}/" 2>/dev/null || true

echo "Cleaning up build artifacts..."
rm "${TARGET_DIR}"_*.changes 2>/dev/null || true
rm "${TARGET_DIR}"_*.buildinfo 2>/dev/null || true
rm "${TARGET_DIR}"_*.build 2>/dev/null || true

# --- Cleanup ---
echo "Cleaning up source directory..."
cd "${TARGET_DIR}"
debuild -- clean
cd ..

echo "Success! Build artifacts are located in: ${OUTPUT_DIR}"

