#!/bin/bash
# Rend tous les scripts de deploy/utils executables.
# A executer une fois apres clone/copie du repo, ou si les bits d'execution
# ont ete perdus (fichiers telecharges, edition sous Windows, etc.).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

chmod +x "$SCRIPT_DIR"/*.sh
chmod +x "$SCRIPT_DIR"/container/*.sh
chmod +x "$SCRIPT_DIR"/timers/*.sh

echo "All deploy/utils scripts are now executable."