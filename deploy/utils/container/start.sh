#!/bin/bash
# Lance manuellement le container sessionrunner (hors systemd).
# Utile pour tester en local ou sur le VPS sans attendre le timer.
#
# Usage : ./start.sh [chemin_vers_env_file]
# Sans argument : essaie /opt/sessionrunner/.env (prod), sinon .env a la racine du repo (local).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

ENV_FILE="${1:-/opt/sessionrunner/.env}"
if [ ! -f "$ENV_FILE" ]; then
    ENV_FILE="$REPO_ROOT/.env"
fi

if [ ! -f "$ENV_FILE" ]; then
    echo "No .env file found (checked /opt/sessionrunner/.env and $REPO_ROOT/.env)" >&2
    exit 1
fi

echo "Using env file: $ENV_FILE"
docker run -d --rm --name sessionrunner --env-file "$ENV_FILE" sessionrunner:latest

echo "Container sessionrunner started."