#!/bin/bash
# Tue le container immediatement (SIGKILL), sans graceful shutdown.
# A utiliser seulement si stop.sh ne suffit pas (process bloque).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker kill sessionrunner

echo "Container sessionrunner force-stopped (SIGKILL)."