#!/bin/bash
set -euo pipefail

# Resolve script directory so this can be run from anywhere
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo systemctl stop sessionrunner-start.timer
sudo systemctl stop sessionrunner-stop.timer

sudo systemctl disable sessionrunner-start.timer
sudo systemctl disable sessionrunner-stop.timer

echo "Timers disabled."