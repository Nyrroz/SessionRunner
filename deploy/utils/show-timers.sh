#!/bin/bash
set -euo pipefail

# Resolve script directory so this can be called from anywhere (not strictly
# necessary for these systemctl calls but keeps behavior consistent)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

systemctl list-timers | grep sessionrunner || true

echo
echo "Start timer:"
systemctl status sessionrunner-start.timer --no-pager || true

echo
echo "Stop timer:"
systemctl status sessionrunner-stop.timer --no-pager || true