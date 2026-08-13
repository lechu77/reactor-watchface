#!/usr/bin/env bash
set -e

# Build and launch REACTOR in Connect IQ Simulator

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

KILL_SIM=false
if [[ "$1" == "--kill" ]]; then
    KILL_SIM=true
    shift
fi

# 1. Compile project
"$PROJECT_ROOT/scripts/build.sh"

SDK_DIR="$HOME/Library/Application Support/Garmin/ConnectIQ/Sdks/connectiq-sdk-mac-9.2.0-2026-06-09-92a1605b2"
CONNECTIQ="$SDK_DIR/bin/connectiq"
MONKEYDO="$SDK_DIR/bin/monkeydo"

if [ "$KILL_SIM" = true ]; then
    # 2. Kill Connect IQ Simulator if running and nuke ALL cached data
    echo "Cleaning up old simulator instances and ALL cached data..."
    pkill -f "ConnectIQ.app" || true
    sleep 1
    # Nuclear cleanup: remove the ENTIRE Garmin simulator temp directory
    # This includes REACTOR.SET, REACTOR.SEN, cached PRG, and all other stale data
    find /var/folders -type d -name "com.garmin.connectiq" -exec rm -rf {} + 2>/dev/null || true
    rm -rf "$TMPDIR/GARMIN" 2>/dev/null || true

    echo "Starting Connect IQ Simulator..."
    "$CONNECTIQ" &
    sleep 4
else
    # Only start simulator if it's not running
    if ! pgrep -f "ConnectIQ.app" > /dev/null; then
        echo "Starting Connect IQ Simulator..."
        "$CONNECTIQ" &
        sleep 4
    fi
fi

# 3. Load watchface binary into simulator
DEVICE="${1:-fenix8pro47mm}"
OUTPUT_PRG="${2:-$PROJECT_ROOT/bin/reactor.prg}"

echo "Loading $OUTPUT_PRG into simulator ($DEVICE)..."
"$MONKEYDO" "$OUTPUT_PRG" "$DEVICE"
