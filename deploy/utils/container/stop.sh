#!/bin/bash
# Arrete proprement le container (SIGTERM, 15s de grace avant SIGKILL).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker stop -t 15 sessionrunner

echo "Container sessionrunner stopped (graceful)."