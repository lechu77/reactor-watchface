#!/usr/bin/env bash
set -e

# REACTOR Garmin Connect IQ Watch Face Release Script
# Builds an .iq package for upload to the Connect IQ Store

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

# Locate monkeyc compiler
if command -v monkeyc &> /dev/null; then
    MONKEYC="monkeyc"
else
    SDK_DIR="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2"
    if [ -f "$SDK_DIR/bin/monkeyc" ]; then
        MONKEYC="$SDK_DIR/bin/monkeyc"
    else
        # Find latest SDK
        LATEST_SDK=$(find "$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks" -name "monkeyc" 2>/dev/null | sort -V | tail -n 1)
        if [ -n "$LATEST_SDK" ]; then
            MONKEYC="$LATEST_SDK"
        else
            echo "Error: monkeyc compiler not found."
            exit 1
        fi
    fi
fi

# Ensure developer key exists
KEY_FILE="$PROJECT_ROOT/developer_key.der"
if [ ! -f "$KEY_FILE" ]; then
    echo "Error: developer_key.der not found! You must generate one to publish."
    echo "Run build.sh first to auto-generate a key, or provide your own."
    exit 1
fi

OUTPUT_DIR="$PROJECT_ROOT/bin"
OUTPUT_IQ="$OUTPUT_DIR/reactor.iq"

mkdir -p "$OUTPUT_DIR"

echo "Building release package (reactor.iq) for Connect IQ Store..."
echo "  Compiler: $MONKEYC"
echo "  Output: $OUTPUT_IQ"

"$MONKEYC" \
    -f monkey.jungle \
    -o "$OUTPUT_IQ" \
    -y "$KEY_FILE" \
    -e \
    -w \
    -l 3 \
    -r

if [ -f "$OUTPUT_IQ" ]; then
    echo "Release build successful! Package created at: $OUTPUT_IQ"
    echo "You can now upload this file to the Garmin Connect IQ Developer Dashboard."
else
    echo "Build failed!"
    exit 1
fi
