#!/bin/bash
# Premiere installation sur un nouveau serveur, a executer UNE SEULE FOIS,
# juste apres `git clone`. Prepare /opt/sessionrunner, build l'image Docker,
# installe les timers systemd.
#
# Usage :
#   git clone <repo>
#   cd SessionRunner
#   ./deploy/utils/init.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ENV_DIR="/opt/sessionrunner"
ENV_FILE="$ENV_DIR/.env"

echo "== 1. Permissions =="
"$SCRIPT_DIR/setup.sh"

echo
echo "== 2. Configuration (.env) =="
if [ ! -f "$ENV_FILE" ]; then
    sudo mkdir -p "$ENV_DIR"

    if [ -f "$REPO_ROOT/.env.example" ]; then
        sudo cp "$REPO_ROOT/.env.example" "$ENV_FILE"
    else
        sudo touch "$ENV_FILE"
    fi

    sudo chmod 600 "$ENV_FILE"

    echo "Created $ENV_FILE (empty template)."
    echo "Edit it now with real credentials:"
    echo "  sudo nano $ENV_FILE"
    read -rp "Press Enter once .env is filled in to continue... "
else
    echo "$ENV_FILE already exists, skipping."
fi

echo
echo "== 3. Docker image =="
"$SCRIPT_DIR/container/build.sh"

echo
echo "== 4. Systemd timers =="
"$SCRIPT_DIR/timers/install-timers.sh"

echo
echo "== Done =="
"$SCRIPT_DIR/show-status.sh"
