#!/bin/bash
# À exécuter lors de la modification seule des horaires dans les fichiers timer.
set -euo pipefail

# Resolve script directory so the script can be invoked from any CWD
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo systemctl daemon-reload

sudo systemctl restart sessionrunner-start.timer
sudo systemctl restart sessionrunner-stop.timer

echo "Timers restarted."