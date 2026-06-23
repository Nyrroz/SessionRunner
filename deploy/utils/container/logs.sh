#!/bin/bash
# Suit les logs du container en direct. Ctrl+C arrete le suivi (ne stoppe pas le container).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker logs -f sessionrunner