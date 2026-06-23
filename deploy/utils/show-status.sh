#!/bin/bash
# Vue d'ensemble : etat du container + etat des timers systemd.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "== Container =="
"$SCRIPT_DIR/container/status.sh"

echo
echo "== Timers =="
"$SCRIPT_DIR/timers/show-timers.sh"